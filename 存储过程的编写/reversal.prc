create or replace procedure reversal(deviceid in device.deviceid%type,
 serial in payfee.bankserial%type, reversalresult out char) is
       opdate payfee.paydate%type;
       payid number;
       paymoney payfee.paymoney%type;
begin
  select p.paymoney
  into paymoney
  from payfee p
  where p.bankserial=serial
  and p.type='2000'
  and p.deviceid=deviceid;
  
  --没有找到就直接
  if paymoney is null then
    reversalresult:='冲正失败！';
    else
      select count(*)
      into payid
      from payfee;
       
      opdate :=  to_date(to_char(sysdate-1,'yyyyMMdd'),'yyyy/MM/dd');
        
      insert into payfee(payfee.type,payfee.id,payfee.deviceid,payfee.paymoney,payfee.paydate,bankcode,bankserial)
      values('2002',payid+100,deviceid,0-paymoney,opdate,19,serial);
      --冲正类型设为2002
      commit;
        
      reversalresult:='冲正成功！';
    end if ; 

  

end reversal;
/
