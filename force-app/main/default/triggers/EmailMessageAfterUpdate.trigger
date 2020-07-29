trigger EmailMessageAfterUpdate on EmailMessage (after insert) {
    AP01_EmailMessage.ChangeCaseStatus(Trigger.newMap);
}