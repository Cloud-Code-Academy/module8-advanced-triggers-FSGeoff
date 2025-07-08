/*
AccountTrigger Overview

This trigger performs several operations on the Account object during its insertion. Depending on the values and conditions of the newly created Account, this trigger can:

1. Set the account's type to 'Prospect' if it's not already set.
2. Copy the shipping address of the account to its billing address.
3. Assign a rating of 'Hot' to the account if it has Phone, Website, and Fax filled.
4. Create a default contact related to the account after it's inserted.

Usage Instructions:
For this lesson, students have two options:
1. Use the provided `AccountTrigger` class as is.
2. Use the `AccountTrigger` from you created in previous lessons. If opting for this, students should:
    a. Copy over the code from the previous lesson's `AccountTrigger` into this file.
    b. Save and deploy the updated file into their Salesforce org.

Let's dive into the specifics of each operation:
*/
/**
 * Created by geoffreynix on 6/19/25.
 */

trigger AccountTrigger on Account (before insert, before update, after insert, after update, before delete, after delete, after undelete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
        }
        when BEFORE_UPDATE {

        }
        when BEFORE_DELETE {

        }
        when AFTER_INSERT {
            /*
  * When an account is inserted change the account
  * type to 'Prospect' if there is no value in the type field.
  * Trigger should only fire on insert.
  */
            for (Account acc: Trigger.new) {
                if (acc.Type == null) {
                    acc.Type = 'Prospect';
                }
                /*
 * When an account is inserted copy the shipping address to the billing address.
 * BONUS: Check if the shipping fields are empty before copying.
 * Trigger should only fire on insert.
 */
                if (acc.ShippingAddress != null) {
                    acc.BillingStreet = acc.ShippingStreet;
                    acc.BillingCity = acc.ShippingStreet;
                    acc.BillingState = acc.ShippingState;
                    acc.BillingPostalCode = acc.ShippingPostalCode;
                    acc.BillingCountry = acc.ShippingCountry;
                }

                /*
* When an account is inserted set the rating to 'Hot' if the Phone, Website, and Fax ALL have a value.
* Trigger should only fire on insert.
*/          if (acc.Phone != null && acc.Website != null && acc.Fax != null) {
                    acc.Rating = 'Hot';
                }
                /*
* When an account is inserted create a contact related to the account with the following default values:
* LastName = 'DefaultContact'
* Email = 'default@email.com'
* Trigger should only fire on insert.
*/
                Contact con = new Contact();
                con.LastName = 'DefaultContact';
                con.Email = 'default@email.com';
                con.AccountId = acc.Id;
            }

        }
        when AFTER_UPDATE {

        }
        when AFTER_DELETE {

        }
        when AFTER_UNDELETE {

        }
    }

}