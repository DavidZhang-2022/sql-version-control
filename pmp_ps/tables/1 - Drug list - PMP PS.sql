/*
********************************************************************************
To be run from main code using proxy access to team schema
********************************************************************************
Created: 			Oct 2022, 		by Bárbara Tencer
Last update: 	Dec 23, 2024, by Bárbara Tencer
Run time: 		<1 min

Creates drug list table for PMP Prescriber Snapshot

*/

drop table &username..&output1 purge;
create table &username..&output1 as

select
	drug_type,
	chemical_name,
	gen_drug,
	drug_brand_nm,
	din_pin,
	gen_drug_strgth,
	gen_strgth_val,
	conversion_factor_val,
	conversion_factor_name,
	conversion_factor_unit,
	gen_dsg_form,
	gen_entry_route_dscr,
	oat_flag,
  pss_flag
  
from &input1
where 
	drug_type in &drugs 
	and pmp_ps_flag = 1
order by
	drug_type,
	chemical_name,
	drug_brand_nm,
	gen_strgth_val,
	gen_dsg_form,
	gen_entry_route_dscr,
	din_pin
;

commit;

--register table
BEGIN
	&username..team_schema_manager.registerObject(ip_objectName => '&output1', ip_objectAlias => '');
END;
/
