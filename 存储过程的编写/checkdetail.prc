create or replace procedure checkdetail(checkdate in char,bankcode in char) is
  ele_serial payfee.bankserial%type;
  ele_money payfee.paymoney%type;
  bank_money bankrecord.payfee%type;
  id number;
  
  cursor ele_cursor is
    select payfee.bankserial, payfee.paymoney
    from payfee 
    where to_char(payfee.paydate,'yyyymmdd') = 
    to_char(to_date(checkdate,'yyyymmdd'),'yyyymmdd')
    and payfee.type='2001'
    and payfee.bankcode = bankcode;
    
begin
   --用payfee中的记录与bankrecord中记录逐一比对
   open ele_cursor;
   loop
     fetch ele_cursor into ele_serial,ele_money;
     exit when ele_cursor%notfound;
     
     select bankrecord.payfee
     into bank_money
     from bankrecord
     where bankrecord.bankserial = ele_serial;
     
     select count(*)
     into id
     from check_exception;
     
     if bank_money is null then
       --payfee中有记录，银行没有 类型设置为111
       insert into check_exception 
       values(id+1,to_date(checkdate,'yyyy/mm/dd'),
       bankcode,ele_serial,null,ele_money,'111');
       commit;
       else 
         if bank_money<>ele_money then
          --都有记录但是钱不一样 类型设置为222
          insert into check_exception 
          values(id+1,to_date(checkdate,'yyyy/mm/dd'),
          bankcode,ele_serial,bank_money,ele_money,'222');
          commit; 
          end if;
          end if;
     
     end loop;
     close ele_cursor;
   
end checkdetail;
/
