import { LightningElement, wire, track } from 'lwc';
import getRedditItems from '@salesforce/apex/GetRedditRecords.getRedditItems';
import { deleteRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

const columns = [
    { label: 'Title', fieldName: 'Title__c', type: 'text'},
    { label: 'Author', fieldName: 'Author__c', type: 'text' },
    { label: 'Thumbnail', fieldName: 'Thumbnail__c', type: 'text' },
    { label: 'Selftext', fieldName: 'Selftext__c', type: 'text' },
    {
        type: "button", typeAttributes: {  
            label: 'Delete',  
            name: 'Delete',  
            title: 'Delete',  
            disabled: false,  
            value: 'delete',  
            iconPosition: 'center',
            iconName: 'utility:record_delete',
            variant: 'destructive'
        }
    },
];

export default class redditService extends LightningElement {
    data = [];
    columns = columns;
    @track wiredItems;

    @wire(getRedditItems)
    wiredRedditItems(result) {
        if(result.data){
            this.wiredItems = result;
            this.data = result.data;
        }
    }

    handleRowAction(event) {
        console.log('eliminar');
        const recordId = event.detail.row.Id;
        this.deleteRow(recordId);
    }

    deleteRow(recordId) {

        deleteRecord(recordId)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Reddit item deleted.',
                        variant: 'success'
                    })
                );
                return refreshApex(this.wiredItems);
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error deleting Reddit item.',
                        message: 'There was an error and the record was not deleted.',
                        variant: 'error'
                    })
                );
            });

    }

}
