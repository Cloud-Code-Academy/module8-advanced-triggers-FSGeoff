/*
OpportunityTrigger Overview

This class defines the trigger logic for the Opportunity object in Salesforce. It focuses on three main functionalities:
1. Ensuring that the Opportunity amount is greater than $5000 on update.
2. Preventing the deletion of a 'Closed Won' Opportunity if the related Account's industry is 'Banking'.
3. Setting the primary contact on an Opportunity to the Contact with the title 'CEO' when updating.

Usage Instructions:
For this lesson, students have two options:
1. Use the provided `OpportunityTrigger` class as is.
2. Use the `OpportunityTrigger` from you created in previous lessons. If opting for this, students should:
    a. Copy over the code from the previous lesson's `OpportunityTrigger` into this file.
    b. Save and deploy the updated file into their Salesforce org.

Remember, whichever option you choose, ensure that the trigger is activated and tested to validate its functionality.
*/
/**
 * Created by geoffreynix on 6/19/25.
 */

trigger OpportunityTrigger on Opportunity (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
        }
        when BEFORE_UPDATE {
            /*
* When an opportunity is updated validate that the amount is greater than 5000.
* Error Message: 'Opportunity amount must be greater than 5000'
* Trigger should only fire on update.
*/
            for(Opportunity opp: Trigger.new) {
                if (opp.Amount != null && opp.Amount < 5000) {
                    opp.addError('Opportunity amount must be greater than 5000');
                }
            }

        }
        when BEFORE_DELETE {
            /*
 * When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
 * Error Message: 'Cannot delete closed opportunity for a banking account that is won'
 * Trigger should only fire on delete.
 */


        }
        when AFTER_INSERT {

        }
        when AFTER_UPDATE {
            /*
* When an opportunity is updated set the primary contact on the opportunity
* to the contact on the same account with the title of 'CEO'.
* Trigger should only fire on update.
*/
            List<Opportunity> triggerOpps = Trigger.new;

//Create a set to store unique account IDs from the updated opportunities.
            Set<Id> oppIds = new Set<Id>();

//Loop through each opportunity in the trigger context:
            for (Opportunity opp: triggerOpps) {
                //   a. Check if the opportunity has an associated account ID.
                if(opp.AccountId != null){
                    //   b. If it does, add the account ID to the set.
                    oppIds.add(opp.AccountId);
                }
            }
// Query for contacts with the title 'CEO' for the collected account IDs.
            List<Contact> ceos = [
                    SELECT Id, AccountId, Name, Title
                    FROM Contact
                    WHERE Title = 'CEO'
                    AND AccountId IN :oppIds
            ];
// Create a map to associate account IDs with their corresponding CEO contacts.
            Map<Id, Contact> ceoList = new Map<Id, Contact>();
// Loop through the queried contacts:
            for (Contact con: ceos) {
                // a. For each contact, add it to the list of CEO contacts for its account ID in the map.
                ceoList.put(con.AccountId, con);

                //7. Loop through the opportunities again:
                for (Opportunity opp: triggerOpps){
                    //  a. For each opportunity, check if the account ID has any associated CEO contacts.
                    if (ceoList.containsKey(opp.AccountId)) {
                        //  b. If a CEO contact exists, set the primary contact field on the opportunity to the CEO contact's ID.
                        opp.Primary_Contact__c = ceoList.get(opp.AccountId).Id;
                    }
                }
            }
        }
        when AFTER_DELETE {

        }
        when AFTER_UNDELETE {

        }
    }

}