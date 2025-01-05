# Task Management System

## Overview

A Salesforce application for managing tasks with the following features:

- Custom Task object
- Lightning Web Component for task management
- Automated task completion via batch processing
- REST API endpoints for task data

## Installation

### Prerequisites

- Salesforce CLI
- Visual Studio Code with Salesforce Extension Pack
- Git

### Setup Steps

- Fork the repository

```https://github.com/hamezksm/task_management.git
```

```bash
# Clone repository
git clone https://github.com/yourusername/task-management.git

# Create scratch org
sf org create scratch -f config/project-scratch-def.json -a TaskOrg

# Deploy metadata
sf project deploy start
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
sf apex test run --tests TaskControllerTest,TaskCompletionBatchTest --resultformat human
```
