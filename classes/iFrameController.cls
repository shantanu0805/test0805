public class iFrameController
{

public boolean flag{get;set;}
public iFrameController()
{
flag=false;
}


public void change(){
system.debug('>>>>>>>>>>>>>>>>'+flag);
flag=true;
     
system.debug('>>>>>>>>>>>>>>>>'+flag);

}
public void hide(){
system.debug('>>>>>>>>>>>>>>>>'+flag);
flag=false;
system.debug('>>>>>>>>>>>>>>>>'+flag);

}
}