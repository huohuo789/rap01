CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Travel RESULT result.

    METHODS HelloWorld FOR MODIFY
      IMPORTING keys FOR ACTION Travel~HelloWorld RESULT result.

    METHODS CreateTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~CreateTravel RESULT result.

    METHODS ApproveTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~ApproveTravel RESULT result.

    METHODS RejectTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~RejectTravel RESULT result.
    METHODS precheck_delete FOR PRECHECK
      IMPORTING keys FOR DELETE Travel.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD HelloWorld.
    DATA ls_result TYPE STRUCTURE FOR ACTION RESULT zi_ps01_travel\\travel~helloworld.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_key>).
      CLEAR ls_result.
      ls_result-%param-Message = |TravelID: { <lfs_key>-%param-TravelID } AgencyID: { <lfs_key>-%param-AgencyID } CustomerID: { <lfs_key>-%param-CustomerID }|.
      ls_result-%param-Type = 'S'.
      ls_result-%cid = <lfs_key>-%cid.

      APPEND ls_result TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD CreateTravel.
    DATA: ls_result TYPE STRUCTURE FOR ACTION RESULT zi_ps01_travel\\travel~createtravel,
          lt_create TYPE TABLE FOR CREATE ZI_PS01_Travel.

    SELECT COUNT( * )
    FROM zi_ps01_travel
    INTO @DATA(lv_count).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_key>).
      lv_count += 1.
      TRY.
          APPEND VALUE #(
              %cid = <lfs_key>-%cid
              traveluuid = cl_system_uuid=>create_uuid_x16_static( )
              travelid = lv_count
              agencyid = <lfs_key>-%param-AgencyID
              customerid = <lfs_key>-%param-CustomerID
              begindate = <lfs_key>-%param-BeginDate
              enddate = <lfs_key>-%param-EndDate
              bookingfee = <lfs_key>-%param-BookingFee
              totalprice = <lfs_key>-%param-TotalPrice
              currencycode = <lfs_key>-%param-CurrencyCode
              description = <lfs_key>-%param-Description
              status = 'O'
          ) TO lt_create.


        CATCH cx_root.
      ENDTRY.
    ENDLOOP.

    MODIFY ENTITY IN LOCAL MODE ZI_PS01_Travel
    CREATE FIELDS ( TravelUUID travelid agencyid customerid begindate Enddate bookingfee totalprice currencycode description status )
    WITH lt_create
    MAPPED DATA(lt_mapped)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    LOOP AT lt_mapped-travel INTO DATA(ls_map).
      CLEAR ls_result.
      DATA lv_msg TYPE c LENGTH 100.

      "Cara SAP Lama"
      READ TABLE keys WITH KEY %cid = ls_map-%cid INTO DATA(lv_desc1).
      IF sy-subrc EQ 0.
        lv_msg = lv_desc1-%param-Description.
      ENDIF.

      ls_result-%param-Message = |Travel Created: { ls_map-Traveluuid } { lv_msg }|.
      ls_result-%param-Type = 'S'.
      ls_result-%cid = ls_map-%cid.

      APPEND ls_result TO result.
    ENDLOOP.

    LOOP AT lt_failed-travel INTO DATA(ls_fail).
      CLEAR ls_result.
      DATA lv_msg2 TYPE c LENGTH 100.

      IF line_exists( keys[ %cid = ls_fail-%cid ] ).
        lv_msg2 = keys[ %cid = ls_fail-%cid ]-%param-Description.
      ENDIF.

      ls_result-%param-Message = |Travel Failed: { ls_fail-Traveluuid } { lv_msg2 }|.
      ls_result-%param-Type = 'E'.
      ls_result-%cid = ls_fail-%cid.

      APPEND ls_result TO result.
    ENDLOOP.
  ENDMETHOD.

  METHOD ApproveTravel.
    MODIFY ENTITY IN LOCAL MODE ZI_PS01_Travel
    UPDATE FIELDS ( Status )
    WITH VALUE #( FOR <k> IN keys ( %tky = <k>-%tky status = 'A' ) ).

    READ ENTITY IN LOCAL MODE ZI_PS01_Travel
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #( FOR ls IN lt_result
                        ( %tky = ls-%tky
                        %param = ls ) ).
  ENDMETHOD.

  METHOD RejectTravel.
    MODIFY ENTITY IN LOCAL MODE ZI_PS01_Travel
    UPDATE FIELDS ( Status )
    WITH VALUE #( FOR <k> IN keys ( %tky = <k>-%tky status = 'X' ) ).

    READ ENTITY IN LOCAL MODE ZI_PS01_Travel
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_result).

    result = VALUE #( FOR ls IN lt_result
                        ( %tky = ls-%tky
                        %param = ls ) ).
  ENDMETHOD.

  METHOD precheck_delete.
    READ ENTITY IN LOCAL MODE ZI_PS01_Travel
     ALL FIELDS
     WITH CORRESPONDING #( keys )
     RESULT DATA(lt_result).

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<lfs_key>).
      READ TABLE lt_result INTO DATA(ls_key) WITH KEY Traveluuid = <lfs_key>-Traveluuid status = 'A'.
      IF sy-subrc EQ 0.
        APPEND VALUE #( %key-Traveluuid = ls_key-Traveluuid ) TO failed-travel.
        APPEND VALUE #( %key-Traveluuid = ls_key-Traveluuid
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error text = |Cannot Delete Approved Travel!| )
                        %delete = if_abap_behv=>mk-on
                        %element-travelid = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
