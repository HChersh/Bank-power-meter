create or replace procedure payrecord(deviceno in device.deviceid%type, fee in number,
ok out char,temp_bankserial out char) is
       paydate payfee.paydate%type;
       payid number;
begin
  select count(*) 
  into payid
  from payfee;

  paydate := to_date(to_char(sysdate-1,'yyyyMMdd'),'yyyy/MM/dd');

  insert into payfee(payfee.type,payfee.id,payfee.deviceid,payfee.paymoney,payfee.paydate,bankcode,bankserial)
  values('2000',payid+100,deviceno,fee,paydate,19,payid+100);
  commit;
  ok:='缴费成功!'; 
  temp_bankserial:=payid+100; 
exception
  when no_data_found then
    dbms_output.put_line('改ID不存在');
  when others then
    dbms_output.put_line('其他错误');

end payrecord;
/
