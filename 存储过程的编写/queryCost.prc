create or replace procedure queryCost(clientno in client.id%type, smoney out number) is

    basicfee number(7,2);
    yearmonth receivables.yearmonth%type;
    dtype device.type%type;
    sysyear number;  
    recordyear number; 
    sysmonth number;
    recordmonth number;

    cursor temp_cursor is
           select r.basicfee,r.yearmonth,d.type
           from client c, device d, receivables r
           where c.id = d.clientid
           and d.deviceid = r.deviceid
           and r.flag = 0 
           and c.id = clientno;
begin
  dbms_output.put_line(round(to_date(20161216,'yyyymmdd') - to_date(20130512,'yyyymmdd'))); 
      smoney:=0;
      open temp_cursor;
      
      loop
        fetch temp_cursor into basicfee,yearmonth,dtype;
        exit when temp_cursor%notfound;
        
            smoney:=smoney+basicfee;
            smoney:=smoney+basicfee*0.08;
            
            if dtype = '01' then
               smoney:= smoney + basicfee*0.1;
               else 
                 smoney:=smoney + basicfee*0.15;
              end if;
            
            sysyear:=to_number(to_char(sysdate,'yyyy'));
            sysmonth:=to_number(to_char(sysdate,'mm'));
            recordyear:=to_number(to_char(to_date(yearmonth,'yyyymm'),'yyyy'));
            recordmonth:=to_number(to_char(to_date(yearmonth,'yyyymm'),'mm'));
            
            if dtype = '02' then
               if sysyear = recordyear and sysmonth > recordmonth then
                 smoney:= smoney + round(sysdate - add_months(to_date(yearmonth,'yyyymm'),1))*basicfee*0.002;
               elsif sysyear > recordyear then
                 smoney:= smoney + round(to_date(1231,'yyyymm') - add_months(to_date(recordmonth,'yyyymm'),1))*basicfee*0.002;
                 smoney:= smoney + round(sysdate - add_months(to_date(recordyear,'yyyy'),12))*basicfee*0.003;
               end if;
            else
              smoney:=smoney + round(sysdate - add_months(to_date(yearmonth,'yyyymm'),1))*basicfee*0.001;
             end if;
               
               
                  
        end loop;
end queryCost;
/
