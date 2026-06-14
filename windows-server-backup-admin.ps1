# Windows Server Backup Administration Runbook
# Company: Aston Villa FC
# Server: FILE01
# Operating System: Windows Server 2022
# Hosts company data used by:
# Finance
# HR
# Ticketing
# Sponsorship
# Operations

# Data Location: D:\CompanyData
# Backup Target: E:\ServerBackups

# Install Windows Server Backup Feature
# Windows Server Backup provides:
# Full Server Backups
# Volume Backups
# System State Backups
# Recovery Options

Install-WindowsFeature `
Windows-Server-Backup

# Verify Installation

Get-WindowsFeature `
Windows-Server-Backup

# Verify Backup Storage

Get-Volume

Get-Disk

# Review Backup Configuration

Get-WBSummary

# View Backup Targets

Get-WBBackupTarget

# View Existing Backup Schedule

Get-WBSchedule

# Create Backup Policy
# Backup - D:\CompanyData
# Backup Destination - E:\ServerBackups

$Policy = New-WBPolicy

$Volume = Get-WBVolume `
-VolumePath "D:"

Add-WBVolume `
-Policy $Policy `
-Volume $Volume

$BackupTarget = New-WBBackupTarget `
-VolumePath "E:"

Add-WBBackupTarget `
-Policy $Policy `
-Target $BackupTarget

Set-WBSchedule `
-Policy $Policy `
-Schedule 22:00

Set-WBPolicy `
-Policy $Policy

# Verify Scheduled Backup

Get-WBSchedule

# View Scheduled Backup Tasks

Get-ScheduledTask |
Where-Object {
    $_.TaskName -like "*Backup*"
}

# Run Manual Backup - Useful for:
# Initial backups
# Backup testing

wbadmin start backup `
-backupTarget:E: `
-include:D: `
-allCritical `
-quiet

# Review Last Backup Result

Get-WBSummary

# View Available Recovery Points

wbadmin get versions

# Review Backup Event Logs
# Useful when:
# Backup jobs fail
# Backup jobs run slowly
# Recovery points are missing

Get-WinEvent `
-LogName Microsoft-Windows-Backup/Operational `
-MaxEvents 50

# View Backup Errors Only

Get-WinEvent `
-LogName Microsoft-Windows-Backup/Operational |
Where-Object {
    $_.LevelDisplayName -eq "Error"
}

# Check Backup Storage Capacity

Get-Volume

Get-PSDrive

# Verify Backup Files Exist

Get-ChildItem `
"E:\ServerBackups"

# Verify Company Data Exists

Get-ChildItem `
"D:\CompanyData"

# Restore Validation
# Backups are useless unless they can actually be restored

wbadmin get versions

# Restore Example - Restore: Finance Folder

wbadmin start recovery `
-version:06/15/2026-22:00 `
-itemType:File `
-items:D:\CompanyData\Finance

# Restore Example - Restore: HR Folder

wbadmin start recovery `
-version:06/15/2026-22:00 `
-itemType:File `
-items:D:\CompanyData\HR

# Verify Restored Files

Get-ChildItem `
"D:\CompanyData\Finance"

Get-ChildItem `
"D:\CompanyData\HR"

# Common Administration Tasks
# View Backup Schedule

Get-WBSchedule

# View Backup Policy

Get-WBSummary

# View Recovery Points

wbadmin get versions

# View Backup Targets

Get-WBBackupTarget

# Verify Backup Service

Get-Service `
wbengine

# Restart Backup Service

Restart-Service `
wbengine

# Backup Monitoring and Health Checks

# Check Backup Service Status

Get-Service wbengine

# Check Backup Service Startup Type

Get-Service wbengine |
Select Name, Status, StartType

# Check Available Recovery Points

wbadmin get versions

# View Backup Disk Usage

Get-Volume

# View Free Space on Backup Drive

Get-PSDrive

# View Backup Event Log Errors Only

Get-WinEvent `
-LogName Microsoft-Windows-Backup/Operational |
Where-Object {
    $_.LevelDisplayName -eq "Error"
}

# View Backup Event Log Warnings Only

Get-WinEvent `
-LogName Microsoft-Windows-Backup/Operational |
Where-Object {
    $_.LevelDisplayName -eq "Warning"
}

# Verify Scheduled Backup Task Exists

Get-ScheduledTask |
Where-Object {
    $_.TaskName -like "*Backup*"
}

# Run Backup Immediately

wbadmin start backup `
-backupTarget:E: `
-include:D: `
-allCritical `
-quiet

# View Running Backup Jobs

Get-Process |
Where-Object {
    $_.ProcessName -like "*wb*"
}

# Verify Backup Destination Contents

Get-ChildItem `
"E:\ServerBackups" `
-Recurse

# Common Scenarios

# User deleted a file
# Steps:
# Locate recovery point
# Restore file
# Verify file integrity
# Confirm user access

# Overnight backup failed
# Steps:
# Review backup logs
# Verify backup storage
# Verify backup service
# Re-run backup
# Confirm successful completion

# Backup destination full
# Steps:
# Check free disk space
# Review retention policy
# Remove obsolete backups
# Verify successful backup

# Ransomware Recovery
# Steps:
# Isolate affected system
# Identify clean recovery point
# Restore data
# Validate restored files
# Return system to service

# Backup Validation Checklist

# Backup completed successfully
# Recovery point created
# Backup storage healthy
# Restore test successful
# Event logs reviewed
# Documentation updated