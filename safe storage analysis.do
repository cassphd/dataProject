/// ******************* PROLOG ******************* ///

	*** DATA: 			raw_safe storage data; clean_safe storage data
	*** AUTHOR: 		Cassandra Crifasi
	*** DATE CREATED: 	07/30/2018
	*** PURPOSE:		reproducibility toolkit
	*** LAST UPDATE: 	08/08/2018

/// ******************* DATA MANAGEMENT ******************* ///


use "C:\Users\ckercher\Desktop\data project\raw_safe storage data.dta"


*** rename variables for ease of analysis ***


*types and number of guns owned* num = number of that type of gun owned

	rename A1 ownHandguns
		rename A1a ownHandguns_num
	
	rename A2 ownRifles
		rename A2a ownRifles_num
	
	rename A3 ownShotguns
		rename A3a ownShotguns_num
	
	rename DOV_GUNS num_gunsOwned
	
	
*location of gun storage* triggerlock = stored with trigger lock
	///lockedin = locked into gun rack
	
	rename B1_1 storagePerson
	
	rename B1_2 storageVehicle
		rename B1_2a storageVehicle_triggerlock
		
	rename B1_3 storageHome
		rename B1_3a storageHome_triggerlock
	
	rename B1_4 storageOutbuilding
		rename B1_4a storageOutbuilding_triggerlock
	
	rename B1_5 storageGunrack
		rename B2_1a storageGunrack_lockedin
		rename B2_1b storageGunrack_triggerlock
	
	rename B1_6 storageGunsafe
	
	rename B1_7 storageGuncase
	
	rename B1_8 storageOther
		rename B2_4b storageOther_triggerlock
		

*how guns are stored* **loaded assumes the gun is assembled**

	rename B3_1 disassembled
	
	rename B3_2 assembledUnloaded
	
	rename B3_3 loadedUnchambered
	
	rename B3_4 loadedChambered
	

*how is ammunition stored* separate = not with gun & together = with gun

	rename B4_1 ammoLocked
	
	rename B4_2 ammoUnlocked_separate
	
	rename B4_3 ammoUnlocked_together
	

*what influenced the way guns are stored*

	rename B5_1 gunCourse
	
	rename B5_2 militaryTraining
	
	rename B5_3 familyDiscuss
	
	rename B5_4 friendDiscuss
	
	rename B5_5 rangeTraining
	
	rename B5_6 onlineInfo
	
	rename B5_7 familyTraining
	
	rename B5_8 friendTraining
	
	rename B5_9 socialMedia
	
	rename B5_10 homeDefense
	
	rename B5_11 gunshopInfo


*most important influence on gun storage*

	rename B6 storageImportant
	

*rate quality of messengers regarding safe storage*

	rename H1_1 messengerFamily
	
	rename H1_2 messengerFriend
	
	rename H1_3 messengerAquaintance
	
	rename H1_4 messengerHuntorgs
	
	rename H1_5 messengerHuntmags
	
	rename H1_6 messengerPhysicians
	
	rename H1_7 messengerPolice
	
	rename H1_8 messengerVeterans
	
	rename H1_9 messengerActivemilitary
	
	rename H1_10 messengerCelebrities
	
	rename H1_11 messengerGundealer
	
	rename H1_12 messengerGunshowmanager
	
	rename H1_13 messengerNRA
	

*demographics provided by survey firm* *underscore to denote data source*

	rename ppagect4 age_4categories
	
	rename ppeducat education_categories
	
	rename ppethm race_ethnicity
	
	rename ppgender gender
	
	rename pphhhead household_head
	
	rename pphhsize household_size
	
	rename pphouse housing_type
	
	rename ppincimp household_income
	
	rename ppmarit marital_status
	
	rename ppmsacat MSA_categories
	
	rename ppreg9 region_categories
	
	rename ppstaten state_residence
	
	rename PPT01 children_1andyounger
	
	rename PPT25 children_2to5years
	
	rename PPT612 children_6to12years
	
	rename PPT1317 children_13to17years
	
	rename ppwork employment_status
	  
	rename pppa1636 military_veteran
		*recode veteran status so that no service is reference group*
		gen mil_vet = 0
		replace mil_vet = 1 if military_veteran == 1
			
			label define mil_vet 0 "No" 1 "Yes"
			label value mil_vet mil_vet

		label variable mil_vet "did you serve active duty military - recoded"

			
*create additional variables for analysis*

	*any child in the home*
	gen anychild = 0
		replace anychild = 1 if /// 
			children_1andyounger != 0 | children_2to5years != 0	|	///
			children_6to12years !=0 | 	children_13to17years !=0
	
	label variable anychild "any children in the home"

	
	*child less than 13 in the home*
	gen youngchild = 0
		replace youngchild = 1 if 		///
			children_1andyounger !=0 | 	children_2to5years !=0 | 	///
			children_6to12years !=0
	
	label variable youngchild "young children in the home"

	
	*child 13 and over in the home*
	gen teenchild = 0
		replace teenchild = 1 if children_13to17years !=0
	
	label variable teenchild "teen children in the home"

			
	*categorical variable for number of guns in the home*
	gen num_gunsOwnedCat = 0
		replace num_gunsOwnedCat = 1 if num_gunsOwned > 1 & num_gunsOwned < 5
		replace num_gunsOwnedCat = 2 if num_gunsOwned >= 5
		
		label define num_gun 0 "1 gun" 1 "2-4 guns" 2 "5 or more guns"
		label values num_gunsOwnedCat num_gun
	
	label variable num_gunsOwnedCat "categorical variable for number of guns owned"

	
	*create a variable for whether respondent only owns handguns*
	gen handgun_only = 0
		replace handgun_only = 1 if ownHandguns == 1 & ///
			ownRifles != 1 & ownShotguns != 1
		
		label variable handgun_only "indicator for whether respondent only owns handguns"

			
	*create collapsed income variable for ease of interpretation*
	gen income = 0
		
		replace income = 1 if household_income == 12 |		///
			household_income == 13 | household_income == 14 | 	///
			household_income == 15
			
		replace income = 2 if household_income == 16 | 	///
			household_income == 17 | household_income == 18 | 	///
			household_income == 19
		
		label define income 0 "Less than $50,000" 1 "50,000 to $99,999" 2 "$100,000 or more"
		label values income income
	
	label variable income "categorical income variable"

		
	*create safe storage variable: all guns locked in safe, cabinet, or case	///
		*or stored with a tigger or other form or lock
	gen safestorage = 0
		replace safestorage = 1 if storageGunsafe == 1 |			///
			storageGuncase == 1 | storageOther == 1 | 					///
			storageHome == 1 & storageHome_triggerlock == 1 |			///
			storageHome == 3 & storageHome_triggerlock == 1 |			///
			storageGunrack == 1 & storageGunrack_lockedin == 1 |		///
			storageGunrack == 3 & storageGunrack_lockedin == 1 |		///
			storageGunrack == 1 & storageGunrack_triggerlock == 1 |		///
			storageGunrack == 3 & storageGunrack_triggerlock == 1 |		///
			storageOther == 3 & storageOther_triggerlock == 1		
	
	label variable safestorage "indicator for whether respondent stores all guns safely at home"

			
save "C:\Users\ckercher\Desktop\data project\clean_safe storage data.dta", replace
	


/// ******************* DATA ANALYSIS ******************* ///


use "C:\Users\ckercher\Desktop\data project\clean_safe storage data.dta", clear

log using "C:\Users\ckercher\Desktop\data project\safe storage output.log", replace

set more off



****


		****** TABLE 1 ******

*where guns are stored*
foreach v of varlist storagePerson storageVehicle storageVehicle_triggerlock ///
	storageHome storageHome_triggerlock storageOutbuilding 					///
	storageOutbuilding_triggerlock storageGunrack storageGunrack_lockedin 	///
	storageGunrack_triggerlock storageGunsafe storageGuncase storageOther 	///
	storageOther_triggerlock {
			svy: tab `v'
			}	
		

*how guns are stored*
foreach v of varlist disassembled assembledUnloaded loadedUnchambered 		///
	loadedChambered {
			svy: tab `v'
			}
	

*Where ammunition is stored*
foreach v of varlist ammoLocked ammoUnlocked_separate ammoUnlocked_together {
			svy: tab `v'
			}

		
		****** TABLE 2 ******

foreach v of varlist gunCourse militaryTraining familyDiscuss friendDiscuss	///
	rangeTraining onlineInfo familyTraining friendTraining socialMedia 		///
	homeDefense gunshopInfo storageImportant {
			svy: tab `v'
			}		
		

		****** TABLE 3 ******
	*combined excellent/good & poor/very poor*

foreach v of varlist messengerFamily messengerFriend messengerAquaintance 	///
	messengerHuntorgs messengerHuntmags messengerPhysicians messengerPolice	///
	messengerVeterans messengerActivemilitary messengerCelebrities 			///
	messengerGundealer messengerGunshowmanager messengerNRA {
			svy: tab `v'
			}		
				
		
		****** TABLE 4 ******

**descriptive demographics**
foreach v of varlist anychild handgun_only num_gunsOwnedCat gunCourse 		///
	familyDiscuss homeDefense region_categories age_4categories 			///
	education_categories marital_status income race_ethnicity gender		///
	MSA_categories mil_vet safestorage {
			svy: tab `v'
			}
		
**simple logistic regression**	
	
foreach x in anychild handgun_only i.num_gunsOwnedCat gunCourse 				///
	familyDiscuss homeDefense i.region_categories i.age_4categories 			///
	i.education_categories i.marital_status i.income i.race_ethnicity i.gender  ///
	i.MSA_categories mil_vet {
			svy: logistic safestorage `x'
			}

**multiple logistic regression**

svy: logistic safestorage anychild handgun_only i.num_gunsOwnedCat gunCourse 	///
	familyDiscuss homeDefense i.region_categories i.age_4categories 			///
	i.education_categories i.marital_status i.income i.race_ethnicity i.gender  ///
	i.MSA_categories mil_vet

 

log close


**create codebook for cleaned dataset**
quietly {
	log using "C:\Users\ckercher\Desktop\data project\storage codebook.log", replace
	noisily codebook, compact
	log close
	}
