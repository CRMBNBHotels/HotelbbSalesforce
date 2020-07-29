trigger AfterUpdateContract on Contract (after update) 
{
	AP01_Contract.UpdateNumberOfContracts(trigger.New, trigger.oldMap,trigger.old);
}