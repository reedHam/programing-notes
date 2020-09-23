From Mysql reference "Transactions are atomic units of work that can be committed or rolled back". In other words a transaction is a small set of database actions with a definite start point to revert the data set to. By default all database actions in mysql are transactions that will auto commit after they are done.

The basic statements for mysql for staring a transaction are. 

    START TRANSACTION
    
This command will explicitly start a transaction and it must be followed by a commit statement.

Or 

    SET SESSION autocommit = 0; 

Disable auto commit for the current client connection.  

    COMMIT

Both of the statements above must be followed by a commit to make the transaction compete.
Otherwise the transaction will be rolled back when the connection closes.

    ROLLBACK

Rolls the currently active transaction back the the starting point of the transaction. 
    


