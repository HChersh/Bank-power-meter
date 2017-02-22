create or replace procedure checkTotal(bankcode IN CHECKRESULT.BANKCODE%type,
totalnum in CHECKRESULT.BANKTOTALCOUNT%type,
totalmoney in CHECKRESULT.BANKTOTALMONEY%type,
checkdate in char,
resultchar out char) is
 id checkresult.id%type;
 checked_totalnum checkresult.banktotalcount%type;
 checked_totalmoney checkresult.banktotalmoney%type; 
 
begin
  select count(*),sum(payfee.paymoney)
  into checked_totalnum,checked_totalmoney
  from payfee 
  where to_char(payfee.paydate,'yyyymmdd')=
  to_char(to_date(checkdate,'yyyymmdd'),'yyyymmdd')
  and bankcode=payfee.bankcode
  and payfee.type='2001';
  
  select to_char(count(*))
  into id
  from checkresult;
  
  if checked_totalmoney=totalmoney
    and checked_totalnum=totalnum then
    insert into checkresult 
    values(id,checkdate,bankcode,totalnum,totalmoney,checked_totalnum,checked_totalmoney);
    commit;
    resultchar:='对账成功！';
    else
      resultchar:='对账失败请调用明细模块！';
 end if;
     
end checkTotal;
/
