// force-app/main/default/lwc/taskList/taskList.js
import { LightningElement, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getTasks from '@salesforce/apex/TaskController.getTasks';
import updateTaskCompletion from '@salesforce/apex/TaskController.updateTaskCompletion';
import { refreshApex } from '@salesforce/apex';

export default class TaskList extends LightningElement {
    @track tasks;
    @track error;
    wiredTasksResult;

    @wire(getTasks)
    wiredTasks(result) {
        this.wiredTasksResult = result;
        if (result.data) {
            this.tasks = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.tasks = undefined;
        }
    }

    handleTaskCompletion(event) {
        const taskId = event.target.dataset.taskid;
        
        updateTaskCompletion({ taskId: taskId })
            .then(() => {
                this.showToast('Success', 'Task marked as completed', 'success');
                return refreshApex(this.wiredTasksResult);
            })
            .catch(error => {
                this.showToast('Error', error.body.message, 'error');
            });
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}
