# Database needs 
In order to call the sync_nsdq_data but first you need the "dblink"
```
CREATE EXTENSION dblink;
SELECT dblink_connect('myconn', 'dbname=mydb user=myuser password=mypass host=localhost');
CALL sync_nsdq_data();
```

