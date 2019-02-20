CS766 HW#2

Name: Han Cao

WiscMail: hcao29@wisc.edu

NetID: 9078133213

### Creteria

1. ##### Roundness

   The roundness of a certain image is independent from the size and orientation, which means, long as the shape of the image won't change, this value won't change. So, i see it as an unique feature of the image.

   I set the creteria as abs(roundness_img_1 - roundness_img_2) < 0.048, it's a resuly of binary search.

2. ##### Emin/Area

   Inertia also has a corralation with the area of the image. When we divide Emin by Area, we get another feature of the image that indepent from the orientation and size of the image. 

   I set the creteria as (abs(target_db(7,j) - obj_db(7,i)) < 63), 63 is also a result of binary search. 

After I set these two creterias right, i got the correct answers.