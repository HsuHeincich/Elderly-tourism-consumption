capture log close
log using charls2013,replace
version 14.0
set more off
clear all
*your commands start
cd D:\CHARLSdata\charls2013\CHARLS2013r
*creat H0.dta
use Health_Status_and_Functioning,clear
keep da048 ID householdID communityID
rename da048 H0
tabulate H0,missing
sort ID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\H0.dta,replace
*creat fmembers
use Family_Information,clear
egen fnum=rownonmiss( cm001_w2_1s1 - cm001_w2_1s25 )
egen onum=anycount( cm002_w2_1_1_ - cm002_w2_1_10_ ),values(1)
gen fmembers= fnum + onum
sort householdID
drop if fmembers==0
keep ID householdID communityID fmembers
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\fmembers1.dta,replace
use Demographic_Background,clear
keep ID householdID communityID be001
tabulate be001,missing
sort ID
merge m:1 householdID using fmembers1,keep(match) nogenerate
gen snum=( be001 ==1)
keep ID householdID communityID snum fmembers
tabulate fmembers,missing
sort ID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\fmembers.dta,replace
*creat gender
use Demographic_Background,clear
keep ID householdID communityID ba000_w2_3
rename ba000_w2_3 gender
tabulate gender,missing
sort ID
save D:\CHARLSdata\charls2013\CHARLS2013r\gender.dta,replace
*creat age.dta
use Demographic_Background,clear
keep ID householdID communityID ba001_w2_1 ba002_1 ba004
sort ID 
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\age2013.dta,replace
use D:\CHARLSdata\charls2011\CHARLS2011r\age.dta,clear
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
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\age2011.dta,replace
use age2013,clear
merge 1:1 ID using age2011
rename age age2011
gen age2013=2013- ba002_1
list if age2013~=ba004 &!missing(ba004) &!missing(age2013)
replace age2013=ba004 if age2013==.
replace age2013=age2011+2 if _merge==2
replace age2013=age2011+2 if _merge==3
rename age2013 age
sum age
sort ID
keep ID householdID communityID age
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\age.dta,replace
*creat hukou.dta
use Demographic_Background,clear
keep ID householdID communityID bc001 bc001_w2_1 bc002
tabulate bc001,missing
rename bc001 hukou2013
/*replace hukou2013= bc002 if hukou2013==3
tabulate hukou2013,missing
sort ID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\hukou2013.dta,replace  
use D:\CHARLSdata\charls2011\CHARLS2011r\hukou.dta,clear
/*2011 is consistent with 2013,ID householdID*/
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
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\hukou2011.dta,replace
use hukou2013,clear
merge 1:1 ID using hukou2011
rename hukou hukou2011
replace hukou2013=hukou2011 if bc001_w2_1~=. & hukou2013==. &bc001_w2_1==2
replace hukou2013=hukou2011 if _merge==2
replace hukou2013=1 if _merge==3 & bc001_w2_1==1 & hukou2011==2 & hukou2013==.
replace hukou2013=2 if _merge==3 & bc001_w2_1==1 & hukou2011==1 & hukou2013==.
keep ID householdID communityID hukou2013*/
rename hukou2013 hukou
tabulate hukou,missing
sort ID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\hukou.dta,replace
*creat edu.dta
use Demographic_Background,clear
keep ID householdID communityID bd001_w2_1 bd001_w2_3 bd001_w2_4 bd001 bd002 bd002_w2_1
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\edu2013.dta,replace
use D:\CHARLSdata\charls2011\CHARLS2011r\edu.dta,clear
/*2011 is consistent with 2013,ID householdID*/
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
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\edu2011.dta,replace
use edu2013,clear
merge 1:1 ID using edu2011
rename edu edu2011
replace bd001=bd001_w2_3 if bd001_w2_1==2
gen edu2013=0 if bd001==1
replace edu2013 = bd002 if bd001==2
replace edu2013 = 3 if bd001==3
replace edu2013=6 if bd001==4
replace edu2013=9 if bd001==5
replace edu2013=12 if bd001==6 | bd001==7
replace edu2013=15 if bd001==8
replace edu2013=16 if bd001==9
replace edu2013=19 if bd001==10
replace edu2013=23 if bd001==11
replace edu2013=edu2011 if bd001_w2_1==1 & _merge==3
replace edu2013=edu2011 if _merge==2
replace edu2013=edu2011 if bd001_w2_4==12 & edu2013==.
keep ID householdID communityID edu2013
rename edu2013 edu
tabulate edu,missing
sort ID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\edu.dta,replace
*creat marriage.dta
use Demographic_Background,clear
keep ID householdID communityID be001
gen marriage= be001
replace marriage=1 if be001==1
replace marriage=2 if be001==2 | be001==3
replace marriage=3 if be001==4
replace marriage=4 if be001==5
replace marriage=5 if be001==6 | be001==7
label define marriage 1"Married living together" 2"Married different living" 3"Divorced" 4"Widowed" 5"unmarried"
label values marriage marriage
tabulate marriage,missing
keep ID householdID communityID marriage
sort ID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\marriage.dta,replace
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
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\livemode.dta,replace
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
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\SRH.dta,replace
*creat SC.dta(Structure SC)
use health_status_and_functioning,clear
keep ID householdID communityID da056s1-da056s12
egen da056s1_s11=rownonmiss( da056s1 - da056s11 )
drop if da056s1_s11~=0&da056s12==12
egen SC=rownonmiss(da056s1 - da056s8)
drop da*
tab SC
sort ID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\SC.dta,replace
*creat smok.dta
use health_status_and_functioning,clear
keep ID householdID communityID da059 da061
gen smok2013=1 if da061==1
replace smok2013=0 if da061==2
replace smok2013=0 if smok2013==. & da059==2
replace smok2013=1 if smok2013==. & da059==1
tabulate smok2013,missing
sort ID
keep ID householdID communityID da059 da061 smok2013
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\smok2013.dta,replace
use D:\CHARLSdata\charls2011\CHARLS2011r\smok.dta,clear
/*2011 is consistent with 2013,ID householdID*/
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
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\smok2011.dta,replace
use smok2013,clear
merge 1:1 ID using smok2011
rename smok smok2011
replace  smok2013=smok2011 if smok2013==.
keep ID householdID communityID smok2013
rename smok2013 smok
label define smok 0"no" 1"yes"
label values smok smok
tabulate smok,missing
sort ID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\smok.dta,replace
*creat medicare.dta
use health_care_and_insurance,clear
keep ID householdID communityID ea001s1- ea001s11
egen medicare=rownonmiss(ea001s1- ea001s10)
replace medicare=1 if medicare~=0
replace medicare=. if medicare==0 & ea001s11==.
label define medicare 1"yes" 0"no"
label values medicare medicare
tabulate medicare,missing
keep ID householdID communityID medicare
sort ID
save D:\CHARLSdata\charls2013\CHARLS2013r\medicare.dta,replace
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
drop d*
tabulate MH,missing
label define mh 1"very good" 2"good" 3"bad" 4"very bad"
label values MH mh
tabulate MH,missing
sort ID
save D:\CHARLSdata\charls2013\CHARLS2013r\MH.dta,replace
*your commands end

*your commands start
*creat income
use Family_Transfer,clear
sum ce002_1 ce002_3
egen income_par=rowtotal(ce002_1 ce002_3)/*income from parents*/
sum ce005_1 ce005_3
egen income_parinlaw=rowtotal(ce005_1 ce005_3)/*income from parents_in_law*/
sum ce009_1_1_-ce009_1_11_ ce009_1_15_ ce009_3_1_-ce009_3_11_ ce009_3_15_
egen income_kid=rowtotal(ce009_1_1_-ce009_1_11_ ce009_1_15_ ce009_3_1_-ce009_3_11_ ce009_3_15_)/*income from kid*/
sum ce013_1_1_-ce013_1_11_ ce013_3_1_-ce013_3_11_
egen income_grankid=rowtotal(ce013_1_1_-ce013_1_11_ ce013_3_1_-ce013_3_11_)/*income from grandkid*/
sum ce072_w2
egen income_sib=rowtotal(ce072_w2)/*income from sib*/
sum ce016
egen income_relafri=rowtotal(ce016)/*income from relative and friend*/
sum income*
*creat inc_ftrans.dta
egen inc_ftrans=rowtotal(income*)
sum inc_ftrans
sort householdID
keep ID householdID communityID inc_ftrans
save D:\CHARLSdata\charls2013\CHARLS2013r\inc_ftrans.dta,replace
*creat inc_iwage_sub.dta(R&Spouse)
use individual_income,clear
keep ID householdID communityID ga002_1 ga002_2 ga004_1_1_- ga004_1_9_ ga004_2_1_-ga004_2_9_
sum ga002_1 ga002_2 ga004_1_1_- ga004_1_9_ ga004_2_1_-ga004_2_9_
mvdecode ga00*,mv(0)
mvencode ga00*,mv(0)
replace ga002_2 = 200 in 10010
replace ga002_1=ga002_2*12 if ga002_1~=0 & ga002_2~=0
replace ga002_1=ga002_2*12 if ga002_1==0
rename ga002_1 iwage
sum iwage
foreach i of numlist 1/9{
replace ga004_1_`i'_=ga004_2_`i'_*12 if ga004_1_`i'_~=0 & ga004_2_`i'_~=0
replace ga004_1_`i'_=ga004_2_`i'_*12 if ga004_1_`i'_==0
}
egen isub=rowtotal( ga004_1_1_ - ga004_1_9_ )
sum isub
egen iwage_sub=rowtotal( iwage isub )
sum iwage_sub
sort ID
keep ID householdID communityID iwage isub iwage_sub
save D:\CHARLSdata\charls2013\CHARLS2013r\inc_iwage_sub.dta,replace
*creat inc_fwage_sub.dta(house)
use Household_Income,clear
keep ID householdID communityID ga006* ga008*
sum ga006* ga008*
mvdecode ga00*,mv(0)
mvencode ga00*,mv(0)
foreach i of numlist 1/12{
replace ga006_1_`i'_=ga006_2_`i'_*12 if ga006_1_`i'_~=0 & ga006_2_`i'_~=0
replace ga006_1_`i'_=ga006_2_`i'_*12 if ga006_1_`i'_==0
gen wage`i'=ga006_1_`i'_
}
egen wage=rowtotal( wage1 - wage12 )
sum wage 
sort householdID
save fwage2013,replace
foreach i of numlist 1/9{
foreach j of numlist 1/12{
replace ga008_`i'b_`j'_=ga008_`i'c_`j'_*12 if ga008_`i'b_`j'_~=0 & ga008_`i'c_`j'_~=0
replace ga008_`i'b_`j'_=ga008_`i'c_`j'_*12 if ga008_`i'b_`j'_==0
gen sub`i'_`j'=ga008_`i'b_`j'_
}
}
egen sub=rowtotal(sub*)
egen fwage_sub=rowtotal(wage* sub* )
keep ID householdID communityID wage sub fwage_sub
sum fwage_sub
sort householdID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\inc_fwage_sub.dta,replace
*creat inc_fagri.dta
use Household_Income,clear
keep ID householdID communityID gb005_1 gb008 gb009 gb011_1 gb012_1
drop gb008 gb009
egen fagri=rowtotal( gb005_1 gb011_1 gb012_1 )
sum fagri
keep ID householdID communityID fagri
sort householdID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\inc_fagri.dta,replace
*creat inc_fbus.dta
use Household_Income,clear
keep ID householdID communityID gc005_1_-gc005_3_
sum gc*
replace gc005_1_=. if gc005_1<0
egen fbus=rowtotal(gc005_1_-gc005_3_)
drop gc005_1_-gc005_3_
sum fbus
sort householdID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\inc_fbus.dta,replace
*creat inc_govtra.dta
use Household_Income,clear
keep ID householdID communityID gd001 gd002_1-gd002_7 gd003_1-gd003_3
sum gd001 gd002_1-gd002_7 gd003_1-gd003_3
rename gd001 dibao
egen govsub=rowtotal(gd002_1-gd002_7)
egen othsub=rowtotal(gd003_1-gd003_3)
sum dibao govsub othsub
egen inc_govtra=rowtotal(dibao govsub othsub)
sum inc_govtra
keep ID householdID communityID inc_govtra
sort householdID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\inc_govtra.dta,replace
*creat inc_pen.dta /*Supplement the above pension missing*/
use Work_Retirement_and_Pension,clear
keep ID householdID communityID fn005_w2_1_-fn005_w2_3_ fn042_w2 fn068_w2_1_-fn068_w2_3_ fn079_w2_11 fn082_w2 fn056_w2 fn096_w2
egen pen =rowtotal(fn005_w2_1_-fn005_w2_3_ fn042_w2 fn068_w2_1_ - fn068_w2_3_ fn079_w2_11 fn082_w2 fn056_w2 fn096_w2 )
replace pen=pen*12
sum pen
keep ID householdID communityID pen
sort ID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\inc_pen.dta,replace
*creat inc_rent.dta
use Household_Income,clear
keep ID householdID communityID ha052 ha052_1 ha053 ha053_1 ha060_1_-ha060_4_ ha064 ha064_1
egen Rrent=rowtotal( ha052_1 )
egen Orent=rowtotal( ha053_1 )
gen house_rent=Rrent*12+Orent*12
egen land_rent=rowtotal( ha060_1_ - ha060_4_ )
egen other_rent=rowtotal( ha064_1 )
sum house_rent land_rent other_rent
gen rent= house_rent+ land_rent+ other_rent
sum rent
keep ID householdID communityID rent
sort householdID
save D:\CHARLSdata\CHARLS2013\CHARLS2013r\inc_rent.dta,replace
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
save D:\CHARLSdata\charls2013\CHARLS2013r\inc_owork.dta,replace
*creat inc_inve.dta
use household_income,clear
keep ID householdID communityID ha071
sort householdID
save D:\CHARLSdata\charls2013\CHARLS2013r\inc_inve1.dta,replace
use individual_income,clear
keep ID householdID communityID hc024
sum hc024
sort householdID
merge m:1 householdID using inc_inve1,keep(match) nogenerate
sort householdID
order ID,before(householdID)
sum ha071 hc024
egen inc_inve=rowtotal(ha071 hc024)
sum inc_inve
keep ID householdID communityID inc_inve
sort ID
save D:\CHARLSdata\charls2013\CHARLS2013r\inc_inve.dta,replace
*creat avginc.dta
use fmembers,clear
merge 1:1 ID using inc_iwage_sub,keep(match) nogenerate
merge 1:1 ID using inc_pen,keep(match) nogenerate
merge 1:1 ID using inc_owork,keep(match) nogenerate
merge 1:1 ID using inc_inve,keep(match) nogenerate
sort householdID
save D:\CHARLSdata\charls2013\CHARLS2013r\inc_id.dta,replace
use inc_fwage_sub,clear
merge 1:1 householdID using inc_ftrans,keep(match) nogenerate
merge 1:1 householdID using inc_fagri,keep(match) nogenerate
merge 1:1 householdID using inc_fbus,keep(match) nogenerate
merge 1:1 householdID using inc_govtra,keep(match) nogenerate
merge 1:1 householdID using inc_rent,keep(match) nogenerate
sort householdID
order ID,before(householdID)
save D:\CHARLSdata\charls2013\CHARLS2013r\inc_hid.dta,replace
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
save D:\CHARLSdata\charls2013\CHARLS2013r\avginc.dta,replace
*your commands end
*your commands start
/*bysort:hukou for avginc*/
use avginc,clear
merge 1:1 ID using hukou,keep(match) nogenerate
drop if avginc==0
winsor2 avginc,replace cuts(0.5 99.5) trim
bysort hukou:sum avginc
*your commands end


*your commands start
*creat tfestate.dta
use household_income,clear
egen hper=rowtotal(ha009*)
replace hper=100 if hper>100 & ha007==1
drop if hper>100
gen estate= ha011_1*10000
replace estate= ha011_2* ha001_w2 *1000 if estate==.
mvdecode ha012*,mv(0)
mvencode ha012*,mv(0)
replace estate= 0.5*( ha012_bracket_min + ha012_bracket_max ) if estate==. & ha012_bracket_max <=500000
rename estate est
egen estate=rowtotal(est)
drop if estate<0
drop est
gen percent=0.01*hper
gen festate=0.01*hper*estate
egen loan=rowtotal(ha014)
gen net_festate=festate-loan   /*Current real estate*/
foreach i of numlist 1/4{
gen oestate`i'=ha034_1_`i'_*10000
replace oestate`i'=ha034_2_`i'_*ha051_`i'_*1000 if oestate`i'==.
}
mvdecode ha035_*,mv(0)
mvencode ha035_*,mv(0)
foreach i of numlist 1/2{
replace oestate`i'=0.5*(ha035_`i'_bracket_min+ha035_`i'_bracket_max) if oestate`i'==. & ha035_`i'_bracket_max<=500000
}
egen hper1_1=rowtotal( ha032_1_1_ ha032_2_1_ )
egen hper2_1=rowtotal( ha032_1_2_ ha032_2_2_ )
egen hper3=rowtotal( ha032_1_3_ ha032_2_3_ )
egen hper4=rowtotal( ha032_1_4_ ha032_2_4_ )
egen hper1_2=rowtotal( ha032_3_1_ - ha032_11_1_ )
egen hper2_2=rowtotal( ha032_3_2_ - ha032_11_2_ )
gen hper1= hper1_1+ hper1_2
gen hper2= hper2_1+ hper2_2
foreach i of numlist 1/4{
replace hper`i'=100 if ha030_`i'_==1 & hper`i'>100
drop if hper`i'>100
}
foreach i of numlist 1/4{
gen opercent`i'=0.01*hper`i'
gen ofestate`i'=0.01*hper`i'*oestate`i'
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
gen net_oestate4=oestate4
sum ofestate1-ofestate4
sum net*
egen oestate=rowtotal(ofestate1 ofestate2 ofestate3 ofestate4)
egen net_oestate=rowtotal(net_oestate1 net_oestate2 net_oestate3 net_oestate4)
egen tfestate=rowtotal(festate oestate)
egen net_tfestate=rowtotal(net_festate net_oestate)
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
foreach i of numlist 1/4{
gen landasset`i'=ha055_`i'_*ha057_`i'_
} 
egen landasset=rowtotal(landasset1-landasset4)   /*land asset*/
sum landasset
keep householdID communityID landasset
sort householdID
save landasset,replace
*creat fasset.dta   /*family*/
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
*creat ofmasset
use Household_Income,clear
mvdecode ha074* ha075*,mv(0)
mvencode ha074* ha075*,mv(0)
foreach i of numlist 1/16{
gen netofmasset`i'= ha074_`i'_- ha075_`i'_
}
egen netofmasset=rowtotal(net*)
sum netofmasset
keep ID householdID communityID netofmasset
sort householdID
save ofmasset,replace
*creat net_imasset
use fcash,clear
merge 1:1 ID using idbsf,keep(match) nogenerate
merge 1:1 ID using omasset,keep(match) nogenerate
merge 1:1 ID using hfund,keep(match) nogenerate
merge 1:1 ID using net_orp,keep(match) nogenerate
sort householdID
merge m:1 householdID using net_rp,keep(match) nogenerate
merge m:1 householdID using ofmasset,keep(match) nogenerate
sort ID
merge 1:1 ID using fmembers,keep(match) nogenerate
egen masset=rowtotal( net_rp fcash idbsf omasset hfund net_orp netofmasset )
gen net_imasset=masset/fmembers
sum net_imasset
sort ID
keep ID householdID communityID net_imasset
save net_imasset,replace
*creat ioasset
use fmembers,clear
sort householdID
merge m:1 householdID using landasset,keep(match) nogenerate
merge m:1 householdID using fasset,keep(match) nogenerate
egen oasset=rowtotal( landasset fasset )
gen ioasset= oasset/ fmembers
sum ioasset
sort ID
save ioasset,replace 

*creat iasset.dta
*creat net_fasset.dta
use tfestate,clear
merge 1:1 householdID using landasset,keep(match) nogenerate
merge 1:1 householdID using fasset,keep(match) nogenerate
merge 1:1 householdID using net_rp,keep(match) nogenerate
merge 1:1 householdID using ofmasset,keep(match) nogenerate
egen net_fasset=rowtotal( net_tfestate landasset fasset net_rp netofmasset)
sum net_fasset
sort householdID
keep householdID communityID net_fasset
save net_fasset,replace

*creat net_iasset.dta
use fcash,clear
merge 1:1 ID using omasset,keep(match) nogenerate
merge 1:1 ID using idbsf,keep(match) nogenerate
merge 1:1 ID using hfund,keep(match) nogenerate
merge 1:1 ID using net_orp,keep(match) nogenerate
egen net_iasset= rowtotal(fcash   omasset   idbsf hfund net_orp)
sum net_iasset
keep householdID ID communityID net_iasset
sort householdID
save net_iasset,replace
*creat iasset.dta
use net_fasset,clear
merge 1:m householdID using net_iasset,keep(match) nogenerate
order ID,before(householdID)
egen asset=rowtotal(net_fasset net_iasset)
keep ID householdID communityID asset
sort ID
merge 1:1 ID using fmembers,keep(match) nogenerate
gen iasset=asset/fmembers
sum iasset
sort ID
keep ID householdID communityID iasset
save iasset,replace
*your commands end



/*travel exp*/
use Household_Income,clear
egen travel=rowtotal(ge010_2)
keep ID householdID communityID travel
sum travel
sort householdID
save travel,replace
/*retirement*/
use Work_Retirement_and_Pension,clear
rename fb011 retire
keep ID householdID communityID retire
tabulate retire,missing
sort ID
save retire,replace

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
merge 1:1 ID using retire,keep(match) nogenerate
save pc,replace    /*merge ID*/
/*整合收入，分类整合，检查*/
merge 1:1 ID using avginc,keep(match) nogenerate
/*整合资产，分类整合，检查*/
merge 1:1 ID using iasset,keep(match) nogenerate
merge 1:1 ID using net_iestate,keep(match) nogenerate
merge 1:1 ID using net_imasset,keep(match) nogenerate
merge 1:1 ID using ioasset,keep(match) nogenerate
/*整合旅游消费 */
merge m:1 householdID using travel,keep(match) nogenerate
sort ID
save D:\CHARLSdata\all\final2013_travel_t,replace
use D:\CHARLSdata\charls2013\charls2013r\exp_income_wealth,clear
sort ID
keep ID householdID communityID WEALTH_PC INCOME_PC
save D:\CHARLSdata\all\wealth.dta,replace
cd D:\CHARLSdata\all
use final2013_travel_t,clear
merge 1:1 ID using wealth,keep(match) nogenerate
gen itravel=travel/ fmembers
sum itravel
sort ID 
save final2013_travel,replace
log close
translate charls2013.smcl charls2013.log,replace
