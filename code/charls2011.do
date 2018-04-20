capture log close
log using charls2011,replace
version 14.0
set more off
clear all

*your commands start
cd D:\CHARLSdata\charls2011\CHARLS2011r
*creat H0.dta
use health_status_and_functioning,clear
keep da048 ID householdID communityID
rename da048 H0
tabulate H0,missing
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\H0.dta,replace
*creat fmembers.dta
use household_roster,clear
keep householdID ID communityID a002_1_- a002_16_
egen fnum=rownonmiss(a002_1_- a002_16_)
keep ID householdID communityID fnum
sort householdID
save D:\CHARLSdata\charls2011\CHARLS2011r\fnum.dta,replace
use demographic_background,clear
keep ID householdID communityID be001
tabulate be001
sort householdID
merge m:1 householdID using fnum,keep(match) nogenerate
gen snum=( be001 ==1)
gen fmembers= fnum+ snum+1
tabulate fmembers,missing
keep ID householdID communityID snum fmembers
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\fmembers.dta,replace
*creat gender.dta
use demographic_background,clear
keep ID householdID communityID rgender
rename rgender gender
tabulate gender,missing
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\gender.dta,replace
*creat age.dta
use demographic_background,clear
keep ID householdID communityID ba002_1 ba004
gen age=2011- ba002_1
replace age= ba004 if age==.
keep ID householdID communityID age
sort ID
sum age
save D:\CHARLSdata\charls2011\CHARLS2011r\age.dta,replace
*creat area.dta
use household_roster,clear
keep householdID ID communityID a001
sort householdID
save area,replace
*creat hukou.dta
use demographic_background,clear
keep ID householdID communityID bc001 bc002
rename bc001 hukou
replace hukou= bc002 if hukou==3
tabulate hukou,missing
keep ID householdID communityID hukou
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\hukou.dta,replace
*creat edu.dta
use demographic_background,clear
keep ID householdID communityID bd001 bd002
gen edu=0 if bd001==1
replace edu= bd002 if bd001==2
replace edu=3 if bd001==3
replace edu=6 if bd001==4
replace edu=9 if bd001==5
replace edu=12 if bd001==6 | bd001==7
replace edu=15 if bd001==8
replace edu=16 if bd001==9
replace edu=19 if bd001==10
replace edu=23 if bd001==11
tabulate edu,missing
sort ID
keep ID householdID communityID edu
save D:\CHARLSdata\charls2011\CHARLS2011r\edu.dta,replace
*creat marriage.dta
use Demographic_Background,clear
keep ID householdID communityID be001
gen marriage= be001
replace marriage=1 if be001==1
replace marriage=2 if be001==2 | be001==3
replace marriage=3 if be001==4
replace marriage=4 if be001==5
replace marriage=5 if be001==6 
label define marriage 1"Married living together" 2"Married different living" 3"Divorced" 4"Widowed" 5"unmarried"
label values marriage marriage
tabulate marriage,missing
keep ID householdID communityID marriage
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\marriage.dta,replace
*creat livemode.dta
use fmembers,clear
gen livemode=3 if fmembers>2
replace livemode=1 if fmembers==1
replace livemode=2 if fmembers==2 & snum==1
replace livemode=3 if fmembers==2 & snum==0
label define livemode 1"alone" 2"only with spouse" 3"Multi-generation"
label values livemode livemode
tabulate livemode,missing
keep ID householdID communityID livemode
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\livemode.dta,replace
*create SRH.dta
use health_status_and_functioning,clear
keep ID householdID communityID da001 da002 da079 da080
gen SRH2= da002
replace SRH2=da079 if SRH2==.
tabulate SRH2,missing
gen SRH1= da001
replace SRH1=da080 if SRH1==.
tabulate SRH1,missing
label values SRH1 da001
label values SRH2 da002
tab1 SRH1 SRH2,missing
keep ID householdID communityID SRH1 SRH2
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\SRH.dta,replace
*creat SC.dta(Structure SC)
use health_status_and_functioning,clear
keep ID householdID communityID da056s1-da056s12
egen da056s1_s11=rownonmiss( da056s1 - da056s11 )
drop if da056s1_s11~=0&da056s12==12
egen SC=rownonmiss(da056s1 - da056s8)
drop da*
tab SC
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\SC.dta,replace
*creat smok.dta
use health_status_and_functioning,clear
keep ID householdID communityID da059 da061
gen smok=1 if da061==1
replace smok=0 if da061==2
replace smok=0 if smok==. & da059==2
replace smok=1 if smok==. & da059==1
tabulate smok,missing
label define smoke 1"yes" 0"no"
label values smok smoke
tabulate smok,missing
sort ID
keep ID householdID communityID smok
save D:\CHARLSdata\charls2011\CHARLS2011r\smok.dta,replace
*creat medicare.dta
use health_care_and_insurance,clear
keep ID householdID communityID ea001s1- ea001s10
egen medicare=rownonmiss(ea001s1- ea001s9)
replace medicare=1 if medicare~=0
replace medicare=. if medicare==0 & ea001s10==.
label define medicare 1"yes" 0"no"
label values medicare medicare
tabulate medicare,missing
keep ID householdID communityID medicare
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\medicare.dta,replace
*creat MH.dta
use health_status_and_functioning,clear
keep ID householdID communityID dc009 dc010 dc011 dc012 dc013 dc014 dc015 dc016 dc017 dc018
gen dc013t=1 if dc013==4
replace dc013t=2 if dc013==3
replace dc013t=3 if dc013==2
replace dc013t=4 if dc013==1
gen dc016t=1 if dc016==4
replace dc016t=2 if dc016==3
replace dc016t=3 if dc016==2
replace dc016t=4 if dc016==1
drop dc013 dc016
rename dc013t dc013
rename dc016t dc016
order dc013,after(dc012)
order dc016,after(dc015)
egen depression=rowmean(dc009-dc018)
gen MH=round(depression,1.00)
tabulate MH,missing
gen dc009_t=0 if dc009==1
replace dc009_t=1 if dc009==2
replace dc009_t=2 if dc009==3
replace dc009_t=3 if dc009==4
foreach i of numlist 10/18{
gen dc0`i'_t=0 if dc0`i'==1
replace dc0`i'_t=1 if dc0`i'==2
replace dc0`i'_t=2 if dc0`i'==3
replace dc0`i'_t=3 if dc0`i'==4
}
gen depression2=dc009_t+dc010_t+dc011_t+dc012_t+dc013_t+dc014_t+dc015_t+dc016_t+dc017_t+dc018_t
gen MH2= depression2>=10 if !missing( depression2 )
label variable MH2 "是否抑郁"
label define MH2 1 "1 yes" 0 "0 no"
label values MH2 MH2
tabulate MH2,missing
drop d*
tabulate MH,missing
label define mh 1"very good" 2"good" 3"bad" 4"very bad"
label values MH mh
tabulate MH,missing
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\MH.dta,replace
*your commands end

*your commands start
*creat inc_ftrans.dta
use family_transfer,clear
mvdecode ce00*,mv(-9999)  /*Missing value processing*/
replace ce002_1=ce002_1*1 if ce002_1_every==4
replace ce002_1=ce002_1*2 if ce002_1_every==3
replace ce002_1=ce002_1*4 if ce002_1_every==2
replace ce002_1=ce002_1*12 if ce002_1_every==1
replace ce002_2=ce002_2*1 if ce002_1_every==4
replace ce002_2=ce002_2*2 if ce002_1_every==3
replace ce002_2=ce002_2*4 if ce002_1_every==2
replace ce002_2=ce002_2*12 if ce002_1_every==1
egen inc_par=rowtotal( ce002_1 ce002_2 ce002_3 ce002_4 ) /*income from parents*/
replace ce005_1=ce005_1*1 if ce005_1_every==4
replace ce005_1=ce005_1*2 if ce005_1_every==3
replace ce005_1=ce005_1*4 if ce005_1_every==2
replace ce005_1=ce005_1*12 if ce005_1_every==1
replace ce005_2=ce005_2*1 if ce005_2_every==4
replace ce005_2=ce005_2*2 if ce005_2_every==3
replace ce005_2=ce005_2*4 if ce005_2_every==2
replace ce005_2=ce005_2*12 if ce005_2_every==1
egen inc_parinlaw=rowtotal( ce005_1 ce005_2 ce005_3 ce005_4 ) /*income from parents_in_law*/
foreach i of numlist 1/10{
replace ce009_`i'_1=ce009_`i'_1*1 if ce009_`i'_1_every==4
replace ce009_`i'_1=ce009_`i'_1*2 if ce009_`i'_1_every==3
replace ce009_`i'_1=ce009_`i'_1*4 if ce009_`i'_1_every==2
replace ce009_`i'_1=ce009_`i'_1*12 if ce009_`i'_1_every==1
replace ce009_`i'_2=ce009_`i'_2*1 if ce009_`i'_2_every==4
replace ce009_`i'_2=ce009_`i'_2*2 if ce009_`i'_2_every==3
replace ce009_`i'_2=ce009_`i'_2*4 if ce009_`i'_2_every==2
replace ce009_`i'_2=ce009_`i'_2*12 if ce009_`i'_2_every==1
egen ce009_`i'_chinc=rowtotal(ce009_`i'_1 ce009_`i'_2 ce009_`i'_3 ce009_`i'_4)
}
egen inc_kid=rowtotal( ce009_1_chinc - ce009_10_chinc )  /*income from kids*/
foreach i of numlist 1/10{
replace ce013_`i'_1=ce013_`i'_1*1 if ce013_`i'_1_every==4
replace ce013_`i'_1=ce013_`i'_1*2 if ce013_`i'_1_every==3
replace ce013_`i'_1=ce013_`i'_1*4 if ce013_`i'_1_every==2
replace ce013_`i'_1=ce013_`i'_1*12 if ce013_`i'_1_every==1
replace ce013_`i'_2=ce013_`i'_2*1 if ce013_`i'_2_every==4
replace ce013_`i'_2=ce013_`i'_2*2 if ce013_`i'_2_every==3
replace ce013_`i'_2=ce013_`i'_2*4 if ce013_`i'_2_every==2
replace ce013_`i'_2=ce013_`i'_2*12 if ce013_`i'_2_every==1
egen ce013_`i'_gchinc=rowtotal(ce013_`i'_1 ce013_`i'_2 ce013_`i'_3 ce013_`i'_4)
}
egen inc_gkid=rowtotal( ce013_1_gchinc - ce013_10_gchinc )  /*income from gkids*/
replace ce016_1=ce016_1*1 if ce016_1_every==4
replace ce016_1=ce016_1*2 if ce016_1_every==3
replace ce016_1=ce016_1*4 if ce016_1_every==2
replace ce016_1=ce016_1*12 if ce016_1_every==1
replace ce016_2=ce016_2*1 if ce016_2_every==4
replace ce016_2=ce016_2*2 if ce016_2_every==3
replace ce016_2=ce016_2*4 if ce016_2_every==2
replace ce016_2=ce016_2*12 if ce016_2_every==1
egen inc_rela=rowtotal( ce016_1 ce016_2 ce016_3 ce016_4 ) /*income from relatives*/
replace ce019_1=ce019_1*1 if ce019_1_every==4
replace ce019_1=ce019_1*2 if ce019_1_every==3
replace ce019_1=ce019_1*4 if ce019_1_every==2
replace ce019_1=ce019_1*12 if ce019_1_every==1
replace ce019_2=ce019_2*1 if ce019_2_every==4
replace ce019_2=ce019_2*2 if ce019_2_every==3
replace ce019_2=ce019_2*4 if ce019_2_every==2
replace ce019_2=ce019_2*12 if ce019_2_every==1
egen inc_fri=rowtotal( ce019_1 ce019_2 ce019_3 ce019_4 ) /*income from friends*/
/*creat inc_ftrans*/
egen inc_ftrans=rowtotal(inc_par inc_parinlaw inc_kid inc_gkid inc_rela inc_fri)
sum inc_ftrans
sort householdID
keep ID householdID communityID inc_ftrans
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_ftrans.dta,replace
*creat inc_iwage_sub.dta(R&Spouse)
use individual_income,clear
keep ID householdID communityID ga002 ga002_1 ga004_1_1_-ga004_1_11_ ga004_2_1_- ga004_2_11_
sum ga002 ga002_1 ga004_1_1_-ga004_1_11_ ga004_2_1_- ga004_2_11_
mvdecode ga00*,mv(0)
mvencode ga00*,mv(0)
replace ga002=ga002_1*12 if ga002~=0&ga002_1~=0
replace ga002=ga002_1*12 if ga002==0
rename ga002 iwage
sum iwage
foreach i of numlist 1/11{
replace ga004_1_`i'_=ga004_2_`i'_*12 if ga004_1_`i'_~=0 & ga004_2_`i'_~=0
replace ga004_1_`i'_=ga004_2_`i'_*12 if ga004_1_`i'_==0
}
egen isub=rowtotal( ga004_1_1_ - ga004_1_11_ )
sum isub
egen iwage_sub=rowtotal( iwage isub )
sum iwage_sub
sort ID
keep ID householdID communityID iwage isub iwage_sub
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_iwage_sub.dta,replace
*creat inc_fwage_sub.dta(house)
use household_income,clear
keep ga008* ga006* householdID communityID
mvdecode ga008*,mv(0)
mvencode ga008*,mv(0)
foreach i of numlist 1/9 26{
replace ga008_1_a_`i'_=ga008_1_b_`i'_*12 if ga008_1_a_`i'_~=0 & ga008_1_b_`i'_~=0
replace ga008_1_a_`i'_=ga008_1_b_`i'_*12 if ga008_1_a_`i'_==0
}
foreach i of numlist 3/4{
replace ga008_2_a_`i'_=ga008_2_b_`i'_*12 if ga008_2_a_`i'_~=0 & ga008_2_b_`i'_~=0
replace ga008_2_a_`i'_=ga008_2_b_`i'_*12 if ga008_2_a_`i'_==0
}
foreach i of numlist 1/4 6 7 9 11{
replace ga008_3_a_`i'_=ga008_3_b_`i'_*12 if ga008_3_a_`i'_~=0 & ga008_3_b_`i'_~=0
replace ga008_3_a_`i'_=ga008_3_b_`i'_*12 if ga008_3_a_`i'_==0
}
foreach i of numlist 1/4 6{
replace ga008_4_a_`i'_=ga008_4_b_`i'_*12 if ga008_4_a_`i'_~=0 & ga008_4_b_`i'_~=0
replace ga008_4_a_`i'_=ga008_4_b_`i'_*12 if ga008_4_a_`i'_==0
}
foreach i of numlist 1/7{
replace ga008_5_a_`i'_=ga008_5_b_`i'_*12 if ga008_5_a_`i'_~=0 & ga008_5_b_`i'_~=0
replace ga008_5_a_`i'_=ga008_5_b_`i'_*12 if ga008_5_a_`i'_==0
}
foreach i of numlist 1/7 26{
replace ga008_6_a_`i'_=ga008_6_b_`i'_*12 if ga008_6_a_`i'_~=0 & ga008_6_b_`i'_~=0
replace ga008_6_a_`i'_=ga008_6_b_`i'_*12 if ga008_6_a_`i'_==0
}
foreach i of numlist 1/7{
replace ga008_7_a_`i'_=ga008_7_b_`i'_*12 if ga008_7_a_`i'_~=0 & ga008_7_b_`i'_~=0
replace ga008_7_a_`i'_=ga008_7_b_`i'_*12 if ga008_7_a_`i'_==0
}
foreach i of numlist 1/6 8{
replace ga008_8_a_`i'_=ga008_8_b_`i'_*12 if ga008_8_a_`i'_~=0 & ga008_8_b_`i'_~=0
replace ga008_8_a_`i'_=ga008_8_b_`i'_*12 if ga008_8_a_`i'_==0
}
foreach i of numlist 1/7{
replace ga008_9_a_`i'_=ga008_9_b_`i'_*12 if ga008_9_a_`i'_~=0 & ga008_9_b_`i'_~=0
replace ga008_9_a_`i'_=ga008_9_b_`i'_*12 if ga008_9_a_`i'_==0
}
egen ga008_1=rowtotal(ga008_1_a_1_-ga008_1_a_9_ ga008_1_a_26_)
egen ga008_2=rowtotal(ga008_2_a_3_ ga008_2_a_4_)
egen ga008_3=rowtotal(ga008_3_a_1_-ga008_3_a_4_ ga008_3_a_6_ ga008_3_a_7_ ga008_3_a_9_ ga008_3_a_11_)
egen ga008_4=rowtotal(ga008_4_a_1_-ga008_4_a_4_ ga008_4_a_6_)
egen ga008_5=rowtotal(ga008_5_a_1_-ga008_5_a_7_)
egen ga008_6=rowtotal(ga008_6_a_1_-ga008_6_a_7_ ga008_6_a_26_)
egen ga008_7=rowtotal(ga008_7_a_1_-ga008_7_a_7_)
egen ga008_8=rowtotal(ga008_8_a_1_-ga008_8_a_6_ ga008_8_a_8_)
egen ga008_9=rowtotal(ga008_9_a_1_-ga008_9_a_7_)
egen fsub=rowtotal( ga008_1 - ga008_9 )
mvdecode ga006*,mv(0)
mvencode ga006*,mv(0)
foreach i of numlist 1/15{
replace ga006_1_`i'_=ga006_2_`i'_*12 if ga006_1_`i'_==0
}
egen fwage=rowtotal(ga006_1_1_-ga006_1_15_)
gen fwage_sub= fwage+ fsub
sum fwage_sub
sort householdID
keep householdID communityID fwage fsub fwage_sub
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_fwage_sub.dta,replace
*creat inc_fagri.dta
use household_income,clear
keep householdID communityID gb005 gb011 gb012
egen fagri=rowtotal( gb005 gb011 gb012 )
sum fagri
keep householdID communityID fagri
sort householdID 
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_fagri.dta,replace
*creat inc_fbus.dta
use household_income,clear
keep householdID communityID gc005_1_-gc005_3_
replace gc005_1_=. if gc005_1<0
egen fbus=rowtotal(gc005_1_-gc005_3_)
sum fbus
keep householdID communityID fbus
sort householdID
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_fbus.dta,replace
*creat inc_govtra.dta
use household_income,clear
keep householdID communityID gd001_c gd002_1- gd002_7 gd003_1- gd003_3
sum gd001_c gd002_1-gd002_7 gd003_1-gd003_3
list gd002_2 if gd002_2<0
replace gd002_2=. if gd002_2<0
rename gd001_c dibao
egen govsub=rowtotal(gd002_1-gd002_7)
egen othsub=rowtotal(gd003_1-gd003_3)
sum dibao govsub othsub
egen inc_govtra=rowtotal(dibao govsub othsub)
sum inc_govtra
keep householdID communityID inc_govtra
sort householdID
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_govtra.dta,replace
*creat inc_pen.dta 
use work_retirement_and_pension,clear
keep ID householdID communityID fm022 fm034 fn004 fn007 fn013 fn018 fn022
sum fm022 fm034 fn004 fn007 fn013 fn018 fn022
egen pen =rowtotal(fm022 fm034 fn004 fn007 fn013 fn018 fn022)
replace pen=pen*12
sum pen
keep ID householdID communityID pen
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_pen.dta,replace
*creat inc_rent.dta
use household_income,clear
keep householdID communityID ha052_1 ha053_1 ha060_1_-ha060_4_ ha064_1
egen Rrent=rowtotal( ha052_1 )
egen Orent=rowtotal( ha053_1 )
gen house_rent=Rrent*12+Orent*12
egen land_rent=rowtotal( ha060_1_ - ha060_4_ )
egen other_rent=rowtotal( ha064_1 )
sum house_rent land_rent other_rent
gen rent= house_rent+ land_rent+ other_rent
sum rent
keep householdID communityID rent
sort householdID
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_rent.dta,replace
*creat inc_owork.dta
use work_retirement_and_pension,clear
keep ID householdID communityID fc004 fc007 fg002_1_- fg002_10_ fj003 fm059
sum fc004 fc007 fg002_1_- fg002_10_ fj003 fm059
egen fc007_t=rowtotal( fc007 )
replace fc007_t= fc007_t* fc004
egen other_work=rowtotal(fg002_1_- fg002_10_ fj003 fm059)
egen argi_t=rowtotal( fc007_t )
gen owork= argi_t + other_work*12
sum owork
keep ID householdID communityID owork
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_owork.dta,replace
*creat inc_inve.dta
use individual_income,clear
keep ID householdID communityID hc012 hc016 hc017 hc024
replace hc017=. if hc016==2
sum hc012 hc017 hc024
replace hc024=. if hc024<0
egen inve=rowtotal(hc012 hc017 hc024 )
sum inve
keep ID householdID communityID inve
sort householdID
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_inve1.dta,replace
use household_income,clear
keep householdID communityID ha071
sort householdID
merge 1:m householdID using inc_inve1,keep(match) nogenerate
sort householdID
order ID,before(householdID)
sum ha071 inve
egen inc_inve=rowtotal(ha071 inve)
sum inc_inve
keep ID householdID communityID inc_inve
sort ID
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_inve.dta,replace
*creat avginc.dta
use fmembers,clear
merge 1:1 ID using inc_iwage_sub,keep(match) nogenerate
merge 1:1 ID using inc_pen,keep(match) nogenerate
merge 1:1 ID using inc_owork,keep(match) nogenerate
merge 1:1 ID using inc_inve,keep(match) nogenerate
sort householdID
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_id.dta,replace
use inc_fwage_sub,clear
merge 1:1 householdID using inc_ftrans,keep(match) nogenerate
merge 1:1 householdID using inc_fagri,keep(match) nogenerate
merge 1:1 householdID using inc_fbus,keep(match) nogenerate
merge 1:1 householdID using inc_govtra,keep(match) nogenerate
merge 1:1 householdID using inc_rent,keep(match) nogenerate
sort householdID
order ID,before(householdID)
save D:\CHARLSdata\charls2011\CHARLS2011r\inc_hid.dta,replace
use inc_id,clear
merge m:1 householdID using inc_hid,keep(match) nogenerate
sort householdID
order ID,before(householdID)
sort ID
sum fwage_sub fagri fbus inc_govtra rent inc_ftrans iwage_sub pen owork inc_inve
egen income=rowtotal( fwage_sub fagri fbus inc_govtra rent inc_ftrans iwage_sub pen owork inc_inve )
gen avginc= income / fmembers
sort ID
sum avginc
drop iwage_sub fwage_sub
save D:\CHARLSdata\charls2011\CHARLS2011r\avginc.dta,replace
*your commands end

*your commands start
/*bysort:hukou for avginc*/
use avginc,clear
merge 1:1 ID using hukou,keep(match) nogenerate
drop if avginc==0
winsor2 avginc,replace cuts(.5 99.5) trim
bysort hukou:sum avginc
*your commands end

*your commands start
*creat tfestate.dta
use household_income,clear
drop g*
egen hper=rowtotal(ha009*)
replace hper=100 if hper>100 & ha007==1
drop if hper>100
sort householdID
save assets_t,replace
use housing_characteristics,clear
keep householdID communityID i001
sort householdID
merge 1:1 householdID using assets_t,keep(match) nogenerate
gen estate= ha011_1*10000
replace estate= ha011_2* i001*1000 if estate==.
replace estate= 0.5*( ha012_a + ha012_b ) if estate==. & ha012_b<=500000
rename estate est
egen estate=rowtotal(est)
drop if estate<0
drop est
gen percent=0.01*hper
gen festate=0.01*hper*estate
egen loan=rowtotal(ha014)
gen net_festate=festate-loan   /*Current real estate*/
foreach i of numlist 1/3{
gen oestate`i'=ha034_1_`i'_*10000
replace oestate`i'=ha034_2_`i'_*ha051_`i'_*1000 if oestate`i'==.
replace oestate`i'=0.5*(ha035_a_`i'_+ha035_b_`i'_) if oestate`i'==. & ha035_b_`i'_<=500000
}
egen oloan1_t=rowtotal(ha037_1_)
egen oloan2_t=rowtotal(ha037_2_)
gen oloan1=oloan1_t*10000
gen oloan2=oloan2_t*10000
mvdecode oestate*,mv(0)
mvencode oestate*,mv(0)
gen net_oestate1=oestate1-oloan1
gen net_oestate2=oestate2-oloan2
gen net_oestate3=oestate3
sum oestate1-oestate3
sum net*
gen oestate=oestate1+oestate2+oestate3
gen net_oestate=net_oestate1+net_oestate2+net_oestate3   /*Other real estate*/
gen tfestate=festate+oestate
gen net_tfestate=net_festate+net_oestate
sum tf* net_tf*
keep householdID communityID tfestate net_tfestate
sort householdID
save tfestate,replace
/*creta net_iestate*/
use fmembers,clear
sort householdID
merge m:1 householdID using tfestate,keep(match) nogenerate
gen net_iestate= net_tfestate/ fmembers
sum net_iestate
sort ID
keep ID householdID communityID net_iestate
save net_iestate,replace
*creat landasset.dta
use household_income,clear
drop g*
foreach i of numlist 1/4{
gen landasset`i'=ha055_`i'_*ha057_`i'_
} 
egen landasset=rowtotal(landasset1-landasset4)   /*land asset*/
sum landasset
keep householdID communityID landasset
sort householdID
save landasset,replace
*creat fasset.dta
use household_income,clear
egen dgoods=rowtotal( ha065_1_1_ - ha065_1_17_ )
egen ofixssets=rowtotal( ha066_1_1_ - ha066_1_5_ )
egen oasset=rowtotal( ha067 ha068_1 )
sum dgoods ofixssets oasset
egen fasset=rowtotal( dgoods ofixssets oasset )
sum fasset
keep householdID communityID fasset
save fasset,replace
*creat net_rp.dta
use household_income,clear
egen recei=rowtotal(ha070)
egen pay=rowtotal(ha072)
gen net_rp= recei- pay
sum net_rp
keep householdID communityID recei pay net_rp
sort householdID
save net_rp,replace
*creat fcash.dta
use individual_income,clear
egen fcash=rowtotal(hc001)
sum fcash
keep ID householdID communityID fcash
sort ID
save fcash,replace
*creat deposit.dta
use individual_income,clear
egen deposit=rowtotal(hc005)
sum deposit
keep ID householdID communityID deposit
sort ID
save deposit,replace
*creat bonds.dta
use individual_income,clear
egen bonds=rowtotal(hc008)
keep ID householdID communityID bonds
sum bonds
sort ID
save bonds,replace
*creat stock.dta
use individual_income,clear
egen stock=rowtotal(hc013)
keep ID householdID communityID stock
sum stock
sort ID
save stock,replace
*creat fund.dta
use individual_income,clear
egen fund=rowtotal(hc018)
keep ID householdID communityID fund hc020
sum fund
sort ID
save fund,replace
*creat idbsf.dta
merge 1:1 ID using deposit,keep(match) nogenerate
merge 1:1 ID using bonds,keep(match) nogenerate
merge 1:1 ID using stock,keep(match) nogenerate
gen dbsf= deposit+ bonds+ stock+ fund
sum dbsf
mvdecode hc020,mv(0)
mvencode hc020,mv(0)
gen idbsf=0.01*hc020*dbsf
sum idbsf
sort householdID
save idbsf,replace
*creat omasset.dta
use individual_income,clear
egen omasset=rowtotal( hc022 )
sum omasset
keep ID householdID communityID omasset
sort ID
save omasset,replace
*creat hfund.dta
use individual_income,clear
egen hfund=rowtotal( hc028 )
sum hfund
keep ID householdID communityID hfund
sort householdID
save hfund,replace
*creat net_orp.dta
use individual_income,clear
egen oreceive=rowtotal(hc034)
egen cmoney=rowtotal(hc031)
egen biaohui=rowtotal(hc037)
egen oloan=rowtotal(hd001)
egen ocredit=rowtotal(hd003)
gen opay=cmoney+oloan+ocredit+biaohui
sum opay oreceive
gen net_orp= oreceive- opay
sum net_orp
keep ID householdID communityID oreceive opay net_orp
sort ID
save net_orp,replace
*creat iasset.dta
*creat net_iasset.dta
use tfestate,clear
merge 1:1 householdID using landasset,keep(match) nogenerate
merge 1:1 householdID using fasset,keep(match) nogenerate
merge 1:1 householdID using net_rp,keep(match) nogenerate
egen net_fasset=rowtotal( net_tfestate landasset fasset net_rp )
sum net_fasset
sort householdID
keep householdID communityID net_fasset
save net_fasset,replace
use fmembers,clear
merge m:1 householdID using net_fasset,keep(match) nogenerate
gen net_iasset= net_fasset/ fmembers
sum net_iasset
sort ID
save net_iasset,replace
*creat imasset.dta
use fcash,clear
merge 1:1 ID using omasset,keep(match) nogenerate
gen dmasset= fcash+ omasset
sum dmasset
keep householdID ID communityID dmasset
save dmasset,replace
merge 1:1 ID using fmembers,keep(match) nogenerate
gen imasset= dmasset/(snum+1)
sum imasset
sort ID
save imasset,replace
*creat iasset.dta
use net_iasset,clear
merge 1:1 ID using imasset,keep(match) nogenerate
merge 1:1 ID using idbsf,keep(match) nogenerate
merge 1:1 ID using hfund,keep(match) nogenerate
merge 1:1 ID using net_orp,keep(match) nogenerate
gen iasset= net_iasset + imasset+ idbsf+ hfund+ net_orp
sum iasset
save iasset,replace
/*补充变量*/
* creat 记忆力
use Health_Status_and_Functioning,clear
tabulate dc004,missing
gen memory= dc004+6
replace memory=1 if memory==11
replace memory=2 if memory==10
replace memory=3 if memory==9
replace memory=4 if memory==8
replace memory=5 if memory==7
tabulate memory,missing
keep ID householdID communityID memory
label variable memory "记忆力"
label define memory 1 "poor" 2 "fair" 3 "good" 4 "very good" 5 "excellent"
label values memory memory
sort ID
save memory,replace
*creat 生活是否满意
use Health_Status_and_Functioning,clear
tabulate dc028,missing
gen life= dc028<=3 if !missing( dc028 )
tabulate life,missing
label variable life "生活是否满意"
label define life 1 "yes" 0 "no"
label values life life
keep ID householdID communityID life
sort ID
save life,replace
*new社区社会资本newSSC
use "D:\CHARLSdata\charls2011\CHARLS2011r\community.dta",clear
egen newSSC=anycount( jb029_1_1_ - jb029_1_14_ ),values(1)
duplicates drop communityID,force
tabulate newSSC,missing
egen stdnewSSC=std( newSSC )
sum stdnewSSC
keep communityID newSSC stdnewSSC
duplicates drop communityID,force
sort communityID
save newSSC,replace
*your commands end






/*整合个人因素*/
use fmembers,clear
merge 1:1 ID using H0,keep(match) nogenerate 
merge 1:1 ID using gender,keep(match) nogenerate
merge 1:1 ID using age,keep(match) nogenerate
merge 1:1 ID using hukou,keep(match) nogenerate
merge 1:1 ID using edu,keep(match) nogenerate
merge 1:1 ID using marriage,keep(match) nogenerate
merge 1:1 ID using livemode,keep(match) nogenerate
merge 1:1 ID using SRH,keep(match) nogenerate
merge 1:1 ID using SC,keep(match) nogenerate
merge 1:1 ID using smok,keep(match) nogenerate
merge 1:1 ID using medicare,keep(match) nogenerate
merge 1:1 ID using MH,keep(match) nogenerate
merge 1:1 ID using memory,keep(match) nogenerate
sort communityID
merge m:1 communityID using newSSC,keep(match) nogenerate
merge 1:1 ID using life,keep(match) nogenerate
save evar,replace    /*merge ID*/
/*整合收入，分类整合，检查*/
merge 1:1 ID using avginc,keep(match) nogenerate
/*整合资产，分类整合，检查*/
merge 1:1 ID using net_iestate,keep(match) nogenerate
merge 1:1 ID using iasset,keep(match) nogenerate
drop net_fasset net_iasset dmasset imasset hc020 fund deposit bonds stock dbsf idbsf hfund oreceive opay net_orp
gen orasset= iasset- net_iestate
/*2011 is consistent with 2013,ID householdID start*/
gen ID_t1=substr(ID,1,10)
gen ID_t2=substr(ID,-2,2)
gen ID_t=ID_t1+ID_t2
gen householdID_t=substr(ID_t,1,10)
drop ID householdID ID_t1 ID_t2
rename ID_t ID
rename householdID_t householdID
order ID,first
order householdID,after(ID)
sort ID    
/*2011 is consistent with 2013,ID householdID ending*/
save D:\CHARLSdata\all\final2011,replace




log close
translate charls2011.smcl charls2011.log,replace
