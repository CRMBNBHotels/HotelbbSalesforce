trigger AfterDeleteContract on Contract (after delete) 
{
	AP01_Contract.UpdateNumberOfContracts(null, null,trigger.old);
}