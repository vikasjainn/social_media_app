# Blog App
> A rails application with CRUD functionalities where users can register and submit their articles and other users can comment on those articles.

# Features

- [x] 1. Signup +  validation on of length, format of email, password, mobile no 
    - [x] 1.1 Account verification using link(recommended) or OTP(alternate option)

- [x] 2. Login + validation on email and password format
    - [X] 2.1 JWT for authentication and authorization
    - [x] 2.2 Forgot password controller => Action1 - for sending OTP on email, Action2 - for verifying OTP and resetting the password

- [x] 3. Account update using authorisation token 
    - [x] 3.1 Refresh token concept incase of token gets expire (learn and implement)

- [x] 4. Create, update and delete Post  
    - [x] 4.1 Read all post and add pagination  
    - [x] 4.2  Comments (CRUD) on post
    - [x] 4.3 Like and unlike  on Posts and comments (use polymorphic association)
    - [x] 4.4 seprate api for getting all likes on post and comments 

- [x] 5. Add friends - request would be in pending, accepted and decline
    - [x] 5.1  if decline can send friend request again after 30days
    - [X] 5.2 Block user and remove from friend list. so after unblocking also user will not be in his friend list.
  
- [x] 6. Make post public, private and only_friends

- [x] 7. Share post( public and  only_friend only)
  - [x] 7.1 if share post of friend , after unfriend share post should be removed. Or can set set the status of shared post deactivated so that when they become friend again shared post can be visible in his profile. This happens in linkedin if we add some skills and people endorse on that skill. after endorsing we remove it and add again then people who have endorse on that skill will still be visible

- [x] 8. we can attach the profile_pic and cover_pic with account
  - [x] 8.1 we can attach image/images with post and comments
  - [ ] 8.2 we add reaction instead of likes like fb,linkedin,etc do 

- [ ] 9. Repost user - if more than 100 user reported him then account will be blocked
    - [ ] 9.1 Report post - if more than 100 user report a post make that post restricted, even author of the post can't see 

- [ ] 10. limitation on post read by user. free_user - 10 post per_day, premium_user - unlimited. Each day free_user gets credit of 10 post (using sidekiq and cron )

- [ ] 11. subscription for user - free and premium (stripe payment integration) integration)
