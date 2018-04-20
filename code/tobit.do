capture log close
log using example,replace
version 14.0
set more off
cd D:\CHARLSdata\all
*your commands start
use final2013_travel,clear
keep ID householdID communityID itravel fmembers gender age hukou edu SC SRH2 retire avginc  WEALTH_PC INCOME_PC
rename WEALTH_PC iwealth
rename INCOME_PC iincome
drop if hukou>2
drop if iincome<=0
winsor2 iincome iwealth if hukou==0,replace cuts(1 99) trim 
winsor2 iincome iwealth if hukou==1,replace cuts(1 99) trim 
egen mis=rowmiss( _all )
drop if mis
drop mis
gen live=(fmembers==1)
label variable live "是否独居"
label define livealone 0 "no" 1 "yes"
label values live livealone
label variable itravel "家庭人均旅游消费"
label variable fmembers "家庭规模"
label variable gender "受访人性别"
label variable age "受访人年龄"
label variable hukou "受访人户口类型"
label variable edu "受教育年限"
label variable hukou "户口类型"
label variable age "年龄"
label variable gender "性别"
label variable SRH2 "自评健康"
label variable SC "社会参与"
label variable retire "是否退休"
label variable avginc "家庭平均收入"
label variable iwealth "人均家庭财富"
label variable iincome "人均家庭收入"
drop if age<45
drop avginc
sum itravel iincome iwealth edu age    
tab1 SRH2 retire hukou gender live SC,missing
bysort hukou:sum itravel iincome iwealth edu age  
bysort hukou:tab1 SRH2 retire hukou gender live SC,missing
replace gender=0 if gender==2
label define ba000_w2_3 2 "", modify
label define ba000_w2_3 0 "0 femal", add
tabulate gender,missing
replace hukou=0 if hukou==2
label define bc001 2 "", modify
label define bc001 0 "0 Non-agricultural Hukou", add
label define bc001 3 "", modify
label define bc001 4 "", modify
tabulate hukou,missing
gen SRH= SRH2<=3 
label define SRH 0 "not health" 1 "health"
label variable SRH "自评是否健康"
label define SRH 0 "否", modify
label define SRH 0 "no", modify
label define SRH 1 "yes", modify
label values SRH SRH
tabulate SRH,missing
replace retire=0 if retire==2
label define fb011 2 "", modify
label define fb011 0 "0 no", add
tabulate retire,missing
sum itravel iincome iwealth edu age 
tab1 SRH retire hukou gender live SC,missing
bysort hukou:sum itravel iincome iwealth edu age
bysort hukou:tab1 SRH retire hukou gender live SC,missing
gen ageclass=1 if age<60
replace ageclass=2 if age>=60 & age<=70
replace ageclass=3 if age>70
label variable ageclass "年龄段"
bysort ageclass:sum itravel iincome iwealth edu age
bysort ageclass:tab1 SRH retire hukou gender live SC,missing
bysort hukou:sum itravel iincome iwealth edu age if ageclass==1
bysort hukou:tab1 SRH retire hukou gender live SC if ageclass==1,missing
bysort hukou:sum itravel iincome iwealth edu age if ageclass==2
bysort hukou:tab1 SRH retire hukou gender live SC if ageclass==2,missing
bysort hukou:sum itravel iincome iwealth edu age if ageclass==3
bysort hukou:tab1 SRH retire hukou gender live SC if ageclass==3,missing
save final2013_traveltobit,replace


/*模型拟合*/
use final2013_traveltobit,clear
tobit itravel iincome iwealth SRH retire hukou gender edu SC live,ll(0)
estimates store tobit1
tobit itravel iincome iwealth SRH retire gender edu SC live if hukou==0,ll(0)
estimates store tobit2_0
tobit itravel iincome iwealth SRH retire gender edu SC live if hukou==1,ll(0)
estimates store tobit2_1
tobit itravel iincome iwealth SRH retire hukou gender edu SC live if ageclass==1,ll(0)
estimates store tobit3_1
tobit itravel iincome iwealth SRH retire hukou gender edu SC live if ageclass==2,ll(0)
estimates store tobit3_2
tobit itravel iincome iwealth SRH retire hukou gender edu SC live if ageclass==3,ll(0)
estimates store tobit3_3
tobit itravel iincome iwealth SRH retire gender edu SC live if hukou==0 & ageclass==1,ll(0)
estimates store tobit4_0_1
tobit itravel iincome iwealth SRH retire gender edu SC live if hukou==0 & ageclass==2,ll(0)
estimates store tobit4_0_2
tobit itravel iincome iwealth SRH retire gender edu SC live if hukou==0 & ageclass==3,ll(0)
estimates store tobit4_0_3
tobit itravel iincome iwealth SRH retire gender edu SC live if hukou==1 & ageclass==1,ll(0)
estimates store tobit4_1_1
tobit itravel iincome iwealth SRH retire gender edu SC live if hukou==1 & ageclass==2,ll(0)
estimates store tobit4_1_2
tobit itravel iincome iwealth SRH retire gender edu SC live if hukou==1 & ageclass==3,ll(0)
estimates store tobit4_1_3
esttab tobit1,mtitles se star(* 0.1 ** 0.05 *** 0.01)
esttab tobit2*,mtitles se star(* 0.1 ** 0.05 *** 0.01)
esttab tobit3*,mtitles se star(* 0.1 ** 0.05 *** 0.01)
esttab tobit4_0*,mtitles se star(* 0.1 ** 0.05 *** 0.01)
esttab tobit4_1*,mtitles se star(* 0.1 ** 0.05 *** 0.01)
estimates dir


*your commands end
log close
translate example.smcl example.log,replace
