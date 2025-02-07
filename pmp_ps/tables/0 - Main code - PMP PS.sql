/*
********************************************************************************
To be run using proxy access to psd_team_lvl2: username_lvl2[psd_team_lvl2]
********************************************************************************
Created: 		 		Feb 13, 2023,	by Bárbara Tencer
Last update: 		Dec 6, 2024, by Bárbara Tencer
Last run:		 		Jan 10, 2025
Total run time: ~20 min (1 yr, 1 drug)
*/

define startDate = date '2023-04-01';
define endDate	 = date '2024-03-31';

define path 		= "\\SFP.IDIR.BCGOV\s114\S15338\Pharma_Secure\PMP\Requests\2023-03. Prescriber Snapshots\Code"
define username = psd_team_lvl2;

--1) Update drug_list_repository if needed. Match drug list used for
define input1	 = &username..drug_list_repository;
define drugs	 = 'OPIOID';
define output1 = pmp_ps_drug_list;

--2) Dispenses
define input21  = ahip.cb_dtl_ft_dspgevt_vwp;
define input22  = &username..&output1;	--PMP PS drug list
define input23  = sud_team_lvl2.sud_dispenses;--ahip.oat_dspgevt_mvw; --SUD table
define output2  = pmp_ps_dspg;

--3) Dispenses converted to daily
define input31	= &username..&output2;	--PMP PS dspg
define input32	= &username..&output1;	--PMP PS drug list
define output3	= pmp_ps_dspg_daily;

--4) Patients for all periods
define input41	= &username..&output2;	--PMP PS dspg
define input42	= &username..pmp_ps_periods; --PMP PS reporting periods
define output4	= pmp_ps_patients;

--5) Prescriber list
define input51  = &username..&output2;	--PMP PS dspg
define input52  = ahip.phc_plr_identifier_type_map;	--PLR-HI college codes crosswalk
define output5  = pmp_ps_prescriber;

--6) Comparator group assignment for each dispense
define input61  = &username..&output2; --PMP PS dspg
define input62  = &username..&output5; --PMP PS prescriber
define input63  = &username..pmp_ps_91_comp_grp;	--Physicians comparator groups based on college specialty
define output6  = pmp_ps_dspg_comp_grp;	--Note: dispenses that contribute to multiple comparator groups are duplicated in this table
--
--7) Daily dose per patient and user selection
define input71	= &username..&output1;  --PMP PS drug list
define input72	= &username..&output2;	--PMP PS dspg
define input73	= &username..&output3;  --PMP PS dspg daily
define input74  = &username..&output4;  --PMP PS patients
define input75  = &username..&output6; 	--PMP PS comparator group
--define input76	= &username..pa_da_user_selection;	--save for version 2
define output7	= pmp_ps_daily_dose;


--8) Patient counts for all drugs by prescriber, gender and age group
define input81 = ahip.cb_dtl_ft_dspgevt_vwp;
define input82 = &username..&output5; --PMP PS prescriber
define output8 = pmp_ps_all_ptn_cnts;

---------------------------------------------------------------------------------------------------------------
--drop table &output1._old purge;
--drop table &output2._old purge;
--drop table &output3._old purge;
--drop table &output4._old purge;
--drop table &output5._old purge;
--drop table &output6._old purge;
--drop table &output7._old purge;
--drop table &output8._old purge;
--
--rename &output1 to &output1._old;
--rename &output2 to &output2._old;
--rename &output3 to &output3._old;
--rename &output4 to &output4._old;
--rename &output5 to &output5._old;
--rename &output6 to &output6._old;
--rename &output7 to &output7._old;
--rename &output8 to &output8._old;


---------------------------------------------------------------------------------------------------------------

@"&path\1 - Drug list - PMP PS"
@"&path\2 - Dispenses - PMP PS"
@"&path\3 - Dispenses converted to daily - PMP PS"
@"&path\4 - Patient list - PMP PS"
@"&path\5 - Prescriber list - PMP PS"
@"&path\6 - Dispenses comparator group - PMP PS"
@"&path\7 - Daily dose per patient by prescriber and comparator - PMP PS"
@"&path\8 - Patient counts for all drugs - PMP PS"
