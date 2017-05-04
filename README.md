## Yesod-based RESTful Calculator

I was tasked with building a RESTful Calculator web application with the Yesod framework. It supports basic calculator features (i.e. addition, subtraction, multiplication, and division) and has data persistence. Bootstrap is used for the CSS rendering.

### Download and run instructions

0. Install the Haskell Platform (i.e. GHC, cabal, and stack)
1. Clone repo into directory of choice via `https://github.com/petermcneil/yesod-calc.git`
2. Run the project with `stack build && stack exec yesod-calc`
   -- Note this may take a while if you have never run stack.
3. Navigate to `http://localhost:3000`

### Login

Login is written with the yesod-auth-account, and unforutnately you cannot register a new user unless you are willinging to edit the database. This is due to the fact that the package sends out an email with a verification link, and I don't have an email server.

If you would like to use the login feature the test account is..

````
Username: peter
Password: hunter2
`````

If you would like to register an account...

1. Go to the register account page in the web app and register the account
2  Stop the web app from running
3. Open `db/yesod-calc.db` in sqlite3 (i.e. `sqlite3 db/yesod-calc.db`)
4. Find the `userid` by `select * from user order by id desc limit 1;`
5. Update the user entry by `update user set verified=1 where id=userid;`
6. Close `yesod-calc.db` and re-exec `yesod-calc` and login!
