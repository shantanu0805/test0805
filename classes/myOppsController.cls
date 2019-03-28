public class myOppsController
{
private List<Opportunity> opportunities;
public boolean flag{get;set;}
public myOppsController()
{
flag=false;
}

public List<Opportunity> getOpportunities()
{
opportunities = [Select Name, Amount, Account.Name, CloseDate from Opportunity];
flag=true;

return opportunities;
}
public void changevalue(){
system.debug('>>>>>>>>>>>>>>>>'+flag);
flag=true;
system.debug('>>>>>>>>>>>>>>>>'+flag);

}
}