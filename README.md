# Task Manager Salesforce Project

This project implements a task management system in Salesforce, including a custom object, Lightning Web Component, batch processing, and REST API endpoint.

## Setup Instructions

### Prerequisites

- Salesforce CLI installed
- DevHub org enabled
- Visual Studio Code with Salesforce Extensions

### Deployment Steps

1.Clone this repository:

```bash
git clone [repository-url]
cd task-manager-salesforce
```

2.Create a scratch org:

```bash
sfdx force:org:create -f config/project-scratch-def.json -a TaskManagerOrg
```

3.Push the source to your org:

```bash
sfdx force:source:push
```

4.Assign permission set:

```bash
sfdx force:user:permset:assign -n Task_Manager
```

## Component Usage

### Lightning Web Component (taskList)

1. Open Setup > Edit Page in your Salesforce org
2. Drag the "Task List" component onto your page
3. Save and activate the page

### Batch Job Execution

Run the batch job from Developer Console:

```apex
Database.executeBatch(new TaskCompletionBatch());
```

To schedule the batch job:

```apex
String cronExp = '0 0 0 * * ?'; // Runs daily at midnight
System.schedule('Task Completion Job', cronExp, new TaskCompletionBatch());
```

### REST API Endpoint

Test the REST endpoint using cURL:

```bash
curl -X GET https://your-instance.salesforce.com/services/apexrest/tasks \
     -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

Or using Postman:

1. Set the request method to GET
2. URL: `https://your-instance.salesforce.com/services/apexrest/tasks`
3. Add header: `Authorization: Bearer YOUR_ACCESS_TOKEN`

## Features

- Custom Task object with Name, Due Date, and Completion status
- Lightning Web Component for task display and management
- Automated batch processing for overdue tasks
- REST API endpoint for external integration
- SLDS styling for consistent user experience
- Toast notifications for user feedback

## Known Limitations

- Batch job processes all overdue tasks at once (consider implementing chunking for large datasets)
- REST endpoint currently supports GET only
- No bulk update feature in the UI

## Security Considerations

- All Apex classes use "with sharing" to respect sharing rules
- REST endpoint requires proper authentication
- Field-level security should be configured as needed

## Testing

Run tests using:

```bash
sfdx force:apex:test:run --tests TaskCompletionBatchTest --resultformat human
```
