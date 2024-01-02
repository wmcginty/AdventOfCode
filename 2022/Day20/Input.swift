//
//  Input.swift
//  Day20
//
//  Created by Will McGinty on 12/20/22.
//

import Foundation

extension String {

    static let testInput = """
    1
    2
    -3
    3
    -2
    0
    4
    """

    static let input = """
-8622
-8082
-2786
-3978
9280
9282
-2300
-7994
-5918
-458
9787
-929
-9332
-358
-7041
516
6962
6776
7645
-2151
-4431
-8144
-1205
5177
-627
-2786
7076
-2415
8555
6216
-4619
-3300
-1034
-5974
2098
-4512
-2857
-531
2235
8617
-3360
531
-7550
3781
7285
106
5736
-8998
-1563
3137
4603
-7885
8751
6891
117
-6745
-6992
-9233
8392
-3726
-6980
7898
2267
5043
-6565
8449
1734
-3063
-2692
8730
7274
7561
1812
1676
8548
4216
2864
1428
8620
-5974
-1540
-8623
1709
-9336
-6885
586
-2177
-8729
3752
-1376
-8296
-5677
-7268
-9898
4156
4826
-9981
-9756
-1365
-4486
-2228
-4615
3460
6491
-9923
-9635
-889
-6405
-5365
890
-4706
1662
-2039
5482
-8698
6993
-6588
7185
3038
-7800
9730
9673
9260
-4752
6161
-4071
2199
9644
5446
3557
-4378
-6160
-1806
9207
1408
5114
-7717
7659
2759
-2846
-2520
-2999
9035
299
5353
5160
-8437
2437
-2042
-7310
3077
5521
-1234
-9968
1362
-4879
5598
-9611
-8875
4661
8288
6931
-9024
168
5244
-5684
-3143
-2450
-5078
-3269
-6064
-8090
6089
830
9251
2937
-6755
-9665
-8622
3536
6248
3190
-2926
-6372
-8758
-3953
-9974
4233
3234
-1234
2994
-8285
-3789
-30
-9684
-3269
-855
-3544
-5810
7752
4875
-1164
-3503
6959
-6891
-2792
-6000
-6890
-9684
7446
-6977
9135
8442
-9492
-8495
7872
6932
3516
9467
-6040
-2897
1814
2920
-9034
-895
4895
7700
-2982
-5264
1861
-9842
-4198
3175
6850
56
5934
7321
7680
8126
-2357
7057
-18
3943
8577
-9024
8277
7597
-8199
-4138
4601
-9419
1734
-9714
9246
-3541
-9962
-7330
5320
-1803
-258
8910
4659
849
2485
-6240
-2222
-4752
-3766
8990
-1750
7083
-30
8327
2397
-5740
-7367
-9185
-8785
1758
-1439
8332
-2155
-8401
620
7698
2058
3164
-3091
6592
6579
-7247
-4018
-5051
-7014
5728
-5211
-8043
766
2513
-6644
-7960
-8164
2235
1886
-977
4489
91
-3880
-7209
7899
4880
7469
-808
5184
-423
8076
-4349
-1389
-8391
-6096
-4706
2916
2932
-248
-6628
5618
7915
7414
6514
4313
-6270
2864
-2835
9131
2754
4525
7795
-5123
-2691
-7877
-5791
455
9244
-7371
-4268
-4525
-6889
-1612
-6584
6145
91
-5203
-9775
-8643
2629
2091
-7340
-9324
7637
3377
-9532
-2865
-4377
456
-1752
-3018
1575
487
4219
5030
502
8259
-7742
-5064
3024
-4012
7559
-2972
-2183
7062
-7979
7876
-4095
8644
7717
-4905
-6159
7060
8968
456
995
-5344
8948
8205
689
8016
-9057
-4989
4410
9739
-7100
1268
8117
8554
5379
2264
1413
-4523
-5949
2068
-2338
2878
2759
-8016
4912
3814
-1684
-2003
-794
-299
-8156
2143
2881
1900
1520
7664
-6360
-2971
-8622
-4790
-2692
-5544
-1673
2077
-5905
844
-2179
-3302
4606
4600
6993
-7422
-2966
4767
7898
4046
-5085
7159
-5556
5088
4555
-3294
-7800
4811
-4771
-4688
-6936
-9444
-8935
-4113
9251
2008
-7026
3969
-1215
976
-1703
168
-2300
5586
-4530
-3623
3936
-2573
-1698
1043
8332
-1612
-3744
8801
-1652
1362
-9553
-5111
9946
-5806
6525
939
-6431
-1731
2605
-9526
833
8043
-5786
-8746
-2083
-5858
-2956
-1876
3297
-5310
433
7606
4803
-8320
3139
4529
42
7821
2342
565
-3864
-6925
2297
-2897
32
2211
9605
2242
-3187
-7372
5016
7899
-5740
-3173
1273
6656
-5971
-9843
7112
-8025
-2897
7899
2674
6978
-4754
49
-2122
5446
-8973
5049
4107
6281
-5999
-8031
-2720
-8664
5446
-6731
9875
-8882
4999
8074
8102
-1182
-1825
8906
6837
-7569
4035
499
-88
6809
-774
-2965
-2281
362
-5431
-8158
1303
1749
-6721
-6648
-5595
-2778
-117
456
-3966
7200
901
-1664
8407
8989
2004
-249
-1806
4021
-993
7458
-1015
-6533
2644
2765
2242
-7698
-532
1268
5485
3767
9303
-2200
-1606
4175
-5537
-4209
-118
-9697
-7821
8449
-9561
2839
-3550
9783
1657
-1669
3615
-8935
-6280
-7042
2726
-7410
-2741
5184
1219
-4344
-8514
-5949
-2358
991
1597
6155
4695
-9455
-5531
3650
3076
-9185
9831
2399
7142
-6676
6089
-9783
-9675
4832
8995
8760
8769
-8500
-2381
5375
9654
4227
-8817
-8395
9862
-3225
2401
-4183
2973
7157
6938
6562
8917
7717
4298
-3435
-8987
-384
-4619
-9716
-248
-6717
-1323
2342
-228
178
-5294
3555
-3717
2135
-7402
2313
2991
-8131
-1512
-3002
-1752
4245
-1826
1291
3493
7764
-1907
-9556
6127
-8104
2068
-1053
5741
8901
-7994
9710
7460
-8773
-3488
1027
-8831
6592
9113
-4134
2438
-2966
-9273
31
-848
-5675
-3429
8497
-85
5446
-451
-9646
-9763
9239
-3444
-5725
160
-6457
5159
-553
2369
-9905
-8732
-9885
4685
7171
-920
-342
-1534
4574
-794
1400
-8939
-2573
4540
7458
-8075
3421
-8533
9273
1403
4963
-9928
6959
-869
-6792
-1399
-4867
-2625
-6433
2934
-5869
9466
2978
-8612
7814
-1026
5753
3007
-7465
-2892
3546
7862
6087
8224
586
354
-6847
-6004
-1898
9145
6962
9684
-1453
2106
-6496
2594
-8522
8102
-7073
793
-5361
605
2302
110
9527
5696
-198
-8629
-6289
-4045
-4121
110
9832
-4989
-5880
-3292
9943
9908
1188
-1922
-271
5598
-3505
1304
-1435
406
-339
1385
-7476
-4304
890
-1726
8499
3737
3180
-2146
8066
-5990
7736
-7075
5096
-9178
3260
-4631
1323
-7775
-5464
-8446
7379
2936
-2770
-9112
-7290
9907
-9021
2106
5146
-9142
4732
-9405
2371
5482
2535
-5469
4473
-282
-8508
5058
4581
-977
-1060
8196
6491
-5322
-4165
2229
-3084
-7418
729
-1731
8185
4244
-5592
-2786
-5215
-1563
-4013
8531
9783
-8115
4595
-2311
2511
-2569
-1095
-2864
8863
6197
-9660
8231
9854
3784
-5260
7377
-2478
8149
8771
2195
4584
4366
2253
-5122
-4426
-7979
6983
5030
-1376
-3920
-2116
3532
-2965
3433
5630
-2581
7629
-1376
2135
6255
7507
-6282
5512
1338
6311
-3047
-4282
9011
-8431
6749
-3232
226
7377
3538
-355
1896
-6708
-6217
1136
-3173
-8082
5778
3825
8637
-7378
-6372
-3385
3079
-5189
4331
5329
3926
9783
-3117
5039
2839
124
4285
4630
6373
-3337
2940
-186
1896
-3583
7446
-4485
-2407
739
1109
3456
5522
8860
9608
9797
-268
-9471
-2152
-1591
6491
-5159
-7691
1981
-2312
3661
-5761
-5657
9444
-6108
8555
-5668
562
2797
212
-5271
7446
21
-2786
-448
8192
3446
719
-6069
370
-3349
8967
657
3249
7496
3728
1935
7047
2098
2159
-3892
3481
3531
4632
-8067
-6187
-5842
-6763
-1888
6829
-4898
-8533
649
9193
9178
2863
-3912
6742
6394
-3292
-2091
3938
8019
-1940
-743
-5353
1017
-2718
-349
-8612
-9572
-6063
6279
4632
-5813
-3859
899
-6040
-4638
-8787
-2669
4790
-7683
8691
7602
2043
9002
-9922
-3343
-477
5486
-2179
5603
-4967
3807
6830
-907
-3853
1015
-786
-3481
-6622
-6701
7795
2199
-4686
4357
-8470
7132
1608
-1948
-5838
4233
-3965
-3211
4942
-1719
311
5983
-8119
-9865
-7642
7589
1112
8107
-9492
-4980
-7148
5983
1267
-635
6030
267
6857
-4604
-7058
908
-4348
-4413
7335
-8648
-2777
2370
311
-6171
-9837
860
1715
8183
-2263
-2182
-4000
-3887
9432
-669
8042
-3441
9498
548
1484
6006
-249
3923
-1698
5244
-1460
3415
5096
-402
1536
4313
5498
1066
-8060
-6330
-1741
-8452
-4138
7285
5598
-4346
-8729
6491
-9176
-8817
-278
-8879
7847
7112
-4318
-3384
860
-8970
1291
737
-4783
-371
-2993
-526
-6387
-6854
8254
7195
-3978
4655
-7936
-9072
-7951
804
-8773
-3131
3746
8479
4221
-8954
-3660
7613
-4135
-1638
8919
-4406
-9159
3077
6795
-8514
-4115
-2698
1768
99
-5683
1882
8377
3604
6970
8025
-9783
-9535
-2958
-1294
2397
-9784
-423
-6801
-1250
2403
-6956
-7698
-6035
-3867
6454
-5182
-6476
7575
8641
534
8523
-3660
9031
-648
538
3189
-5201
-8430
-8021
2663
1269
9319
-8769
9795
-7140
-4265
-3672
-3211
9619
6006
-4778
-3767
4404
4630
5539
-912
-276
-4917
-6427
9159
-7073
8112
927
2353
-1394
-1394
3919
-5390
-513
-4426
-6767
-796
5736
1303
-6884
-2625
7189
9454
-6721
4950
-2803
-7100
-6582
3103
-5795
-3791
-5826
-4800
9341
8016
-1189
-7614
6581
7539
2913
-8659
605
590
-8164
7398
8231
-902
8392
-8612
-657
1804
928
4053
-9260
-2004
-2718
4317
1227
-4931
-7299
-817
7895
387
-5779
3516
5253
6493
4044
4013
3103
3173
6697
-1988
9303
5415
2159
5046
5842
-5587
3382
9421
-3115
-6513
9614
1744
4529
-9145
-732
9864
8518
8575
-8909
-9004
-4198
-8094
8043
6484
3683
-1522
9341
-2184
-7253
-8886
-9886
-9492
5263
-1620
1082
5093
8686
-4718
-8522
7185
5671
4774
2991
-1022
9325
1671
-8484
5418
-5329
-8926
7272
-2110
-9611
-6702
-675
9822
-1072
-9731
-9493
-4095
7091
-3972
6635
-3942
-1954
-7455
-6034
-8531
-8165
-2641
1739
3542
5928
-85
1643
1150
-2004
1822
-7975
4345
8029
7132
1425
2869
-3349
-7135
-86
-8746
3276
6932
-8877
-6401
-4819
-7348
5993
1792
-3425
-7671
-8730
-1137
-758
-5297
490
7845
4323
5962
-3048
3382
-2155
2413
3171
4802
-9736
-2478
-9403
-3766
7847
-3608
-3227
-8327
-2897
-1881
6089
-3980
5530
-5910
-5075
1094
7377
-8940
6351
-794
-9775
-6801
-6476
-9322
4232
-4523
-9395
-8019
-8514
-5064
8737
-6847
-7695
5325
-8426
-8115
-5592
-4792
5030
4357
9610
-3722
8152
6888
9335
7668
-9042
8152
-2091
105
-5520
-2756
1403
-4054
8287
5667
-2792
-4558
7972
-3425
214
6495
-7782
737
-4199
8503
-5696
752
-4047
-9859
-1591
6035
-8705
4236
-8164
4246
6833
4411
-9077
337
5349
616
-2091
8650
8015
5732
1018
1348
-4362
-310
8760
5674
-5537
7657
9634
8674
-3726
-6614
7910
-4491
-1222
-4165
9346
6021
6289
-6034
1657
3419
7114
447
2433
-2496
2749
-2641
-3726
9537
1138
-5731
-6874
-1549
-7849
-7000
9419
9466
6714
-6668
7234
6337
3640
124
2004
759
8852
-4609
1028
-4389
-5309
50
-8320
2648
6006
-3264
9155
6819
-5692
7950
403
-6144
8559
4891
-3352
7838
3478
-9362
4566
-7861
252
-9513
4207
9969
-1119
-5131
1151
6993
-6014
-3243
-1768
2415
5183
6021
3255
5142
-6034
8112
-1098
-6619
9461
867
-1641
105
8025
-7044
-2958
-7735
-8567
9681
-7983
3615
-6741
7541
-5492
-2662
-2786
-4440
6868
-2273
-4404
9595
-9063
-9611
1041
-7849
1705
-4706
-6288
-7220
-3299
607
4152
-1274
6503
8149
-5390
-3621
-4813
-9097
1188
4616
8133
-180
-6484
-487
8575
-904
-1383
-9279
8043
-1724
-2741
9845
-2348
-9670
4482
457
-9780
5362
-465
-694
2449
9896
-9363
7798
-4875
-7861
-8062
6351
-4344
2330
-6533
5896
-6948
-5190
-1080
-7771
-2549
-6851
-2882
-1397
-1129
2663
-1958
148
-2901
-8314
5511
8239
8583
1291
-553
4515
7640
9392
2765
-7600
-7097
-8622
-3001
-4491
8655
6122
1824
3227
7252
2422
-8766
-84
-2032
-4229
7631
3375
-6245
8289
8269
-7041
8435
8864
-2896
7579
-5010
7836
-659
5961
9655
-5314
7832
-2790
-6360
-6958
1882
-7215
5043
908
7867
-8774
7077
4630
-9643
7887
-1522
-1036
4313
8001
-844
-4326
-975
-1072
8577
-4714
9688
9595
803
-4389
4414
7103
2971
8087
-2809
-9243
2917
-3338
-6776
-1934
-3827
-5302
2746
9245
1291
3496
-2729
-6488
-9025
9835
-249
-4752
4670
1025
5353
8626
21
831
632
879
-4905
-4243
-6758
4739
2474
9461
-1730
7666
1217
5329
-6038
-6952
-8702
-2289
7673
6514
-3433
786
6605
7977
-9466
3161
993
-9620
5241
-9500
7062
-8847
-7350
2681
-5548
5887
-8672
-1621
4653
6110
9614
8620
-9829
-4199
-4426
-3621
5166
-5707
9467
-3632
-7851
-9403
-9686
3661
675
-2650
8178
1755
-7520
8178
-5536
1518
-3126
-2912
4214
9823
-4321
8183
-5841
110
1875
2313
-745
-6547
-7698
-832
-8845
-994
-407
6375
1349
-6405
-9191
1103
4478
-5555
875
-9865
7803
-6875
5890
4691
5413
2931
-4918
7588
595
-2895
4114
-7313
4254
2669
8640
2694
-3681
6311
-7348
9113
8202
5459
-6169
2871
-6644
4244
3060
-5731
8089
-8396
-2834
8814
7486
-9435
-5329
-7292
-5102
-5475
8013
5586
7639
-653
-8531
6368
-7836
-1335
-1174
-9526
8873
-5437
4112
1291
3970
-8095
1319
-4703
6143
5850
8626
9684
9863
8702
-7622
3555
8006
-5880
-5118
5804
1398
9169
-5742
-4244
-8373
4832
8269
-745
-310
-9928
-5589
-7259
-4628
-1246
-7614
5650
-1013
-9862
-4846
-6924
-2665
2362
-2478
6819
1981
4563
-6502
-3299
-2863
2634
8655
-1065
-4719
9251
4244
-7285
1652
4478
-4940
-9675
6915
-7100
5016
8379
-9579
-956
7254
-5526
-1867
8405
8133
4021
7270
-7367
7191
875
-5976
-1482
-8388
-5675
4201
7606
-2876
8760
-3623
-5742
-1340
562
-5117
-83
-3023
9106
8667
-7742
-425
-5035
1118
7062
-9661
-1064
1282
7623
-6996
-3555
6819
6795
7986
8001
1342
-435
4574
-8514
-861
-9776
-6220
8091
-512
6628
6570
-8312
5903
1483
5981
-2653
-3763
-8442
-1354
155
9302
9366
-9737
-579
-2600
-6966
6780
5111
-5735
5197
2438
-2381
8442
-6552
4324
-6552
-9616
-5387
472
2786
-9062
-3151
7807
3775
-4012
6096
4750
740
2502
-1958
3573
-2781
4127
-8758
5495
-4426
-7830
-25
-9047
-7041
9864
4776
-1638
-9014
6206
-315
6190
6930
7373
-7885
263
877
-3509
-4478
6750
-6169
-8216
3268
-960
-4071
-5400
-8155
226
8313
1755
9713
434
-3653
5010
-986
-2809
9300
-4484
-7649
7887
-1786
3746
-6871
7885
-1430
2533
4811
-2351
6887
-4792
6942
8449
-4705
-9717
-6099
3963
-5555
7547
-7904
-6712
-3781
6799
-8746
9139
3410
-3002
4379
-9285
2555
4834
-5260
-174
8299
5530
3898
-5964
-6767
-807
-6412
7944
6808
4046
8275
-2741
-8169
-9826
1268
-3221
-2110
2067
8175
-8630
5370
-6521
-6740
5498
-5549
2973
-2948
2149
2437
-3867
396
2560
-9912
-2122
-9860
-2141
6394
2733
4297
8405
-2180
6190
-5030
-2116
-8215
-4745
5787
-5010
8618
5942
6931
430
-4499
-5886
2289
8089
-5555
1870
-5910
4632
-3046
-6424
4232
-9054
7983
1978
-8331
2108
5841
-2476
-21
7658
-1009
1726
-9877
6255
926
-1190
5738
4835
2723
-9159
7161
-794
7025
-7086
1960
-8006
-912
9754
-9518
-8585
-473
-2080
-710
-8772
-8210
-5169
6246
2438
3116
2457
-3384
-1533
-5013
-3845
-8135
9661
-1577
-1482
-5112
-282
-2863
-8569
6109
-5208
-8331
6863
2721
6776
-581
-3264
-6781
5967
-3097
4694
-5315
7718
-1515
1506
-2062
439
-2897
-3372
57
4752
-3503
9563
7940
8325
3610
-4721
-5650
6136
5406
-4819
-6405
8611
7112
-2004
-5850
-8346
-6999
-1011
-85
-6173
-1638
9555
-7014
438
583
7816
-2952
-9862
-886
-2850
-9598
9481
5384
-2407
-1144
1580
-3723
4699
2811
-2300
-4447
8956
6337
2268
-1651
8655
-7082
7656
-4189
-8694
4832
2952
8671
-9834
3782
-3001
-373
8789
-5319
3088
2511
4046
8446
-5774
5446
-933
-4138
3616
2589
-4989
-6685
6523
7446
-85
9673
3237
4222
-4621
-7967
8259
-2451
-6074
1823
-6567
8229
8894
-2941
-4604
-5860
-5344
6697
-5316
6445
8492
3366
-6781
-636
-8989
5956
7025
6537
-6966
-3134
-9307
-6811
-3744
8261
268
-311
-4929
819
3652
-2956
-1373
-5458
-2668
-5150
4328
6801
1138
1227
4790
-3264
5897
5208
1408
-2265
32
2935
-3726
-4499
3668
-1962
8051
-2305
-3760
5914
-978
3373
-9355
2435
8418
5576
-3581
5822
-5400
6410
-7697
-7800
4641
1425
8672
-3552
-3050
-2193
6399
6830
7266
-7084
483
4410
1949
8325
6326
-2958
6037
-9558
5625
2919
-2477
8791
5238
-7293
5717
-5578
-3907
-3488
1870
4099
8289
-1676
-2672
5522
3141
5914
-2806
-3227
3539
6493
9133
-8063
5870
-7302
-4365
-5806
-9240
-6913
-9879
-4138
-6159
-5165
6727
548
-354
3382
1865
8152
-6891
4824
5177
3731
-194
8377
-6066
-2467
3116
-231
2099
4978
8311
7920
-4166
-2231
-6770
-1933
-481
-8320
-9780
-2884
5415
-2882
-5232
7615
5858
331
7261
615
3275
5962
-9847
-6065
2656
-7000
-3786
-4367
537
-1676
-8143
-2309
-8814
4328
-7084
-728
6096
8494
-1393
895
-1375
-1391
-249
1164
1132
-2299
-572
2068
5093
-3245
-6202
6759
-7672
1435
-5816
1935
2422
-2958
-8812
-585
9579
-2958
5560
-6173
430
3134
4952
-2668
-5085
-9521
-1361
-84
7661
2727
-6986
5046
8024
-9928
-3080
6209
5729
5888
6827
-4545
3750
1413
-9146
-757
8231
-6220
8420
-2192
-8568
-4446
-7743
-6722
-8974
-7388
-1375
8847
2422
1880
620
7998
3316
6798
-132
1624
-1895
-2266
-7850
-9125
7590
4962
7613
-6900
-5779
2848
3970
-8622
-9547
4216
-4934
144
-7733
444
9184
-7397
6197
4363
-7772
-9882
-7390
4015
5554
-8168
8864
2107
8348
-6966
3620
7797
-2209
7350
-710
-9928
-9922
5921
3332
7845
-7292
-8758
8006
2797
-6406
2739
-4680
1571
2612
7922
-3232
-5234
5418
-3316
-7116
6819
8140
4962
-5687
-259
821
4053
-9370
-1793
-2131
-8215
8015
-4749
8348
6152
1227
-9168
2515
9567
-4404
-999
-6980
430
5452
890
9141
-1984
2747
-9823
-8096
-1545
1393
-4896
5147
-4746
-9574
-202
4632
992
-2531
9614
4420
8074
-5794
5761
7062
-5807
-9071
-262
-4611
-2752
-2094
4311
-8454
9340
-4850
518
-8174
7168
-4339
8133
-7515
1349
-4819
-7676
3781
-855
-4078
7398
-2470
-3555
6678
-775
8229
6443
-1929
-3316
-4703
9944
3716
-5531
2645
-7742
675
7446
9201
5213
-4441
-4754
-9619
-8791
559
2668
-3854
-2389
-9013
-8142
4569
8748
8760
8418
9476
-7693
8644
3136
-9826
9475
-6159
3230
5246
-7048
4796
-5779
-7932
6864
324
9792
-1397
1026
4014
7738
-8376
-7765
-8062
1470
-5792
7957
-9929
6516
-9149
3648
-4166
-5779
-7041
-8913
581
5783
-9237
-3443
5253
-682
-180
-7362
-6215
3504
2329
1874
-6827
-3722
1046
7706
6375
-2418
-8783
-44
-4755
1912
-905
-4349
7145
-6266
1476
-423
9295
-4513
-4441
446
-9060
-5499
-1174
8231
2664
-2856
5826
7264
-8886
-2566
5001
1687
-920
391
-1072
-5858
3343
6759
-263
8509
6564
-6697
8349
-4333
5823
-5129
9897
-8663
3433
3180
-8471
-5625
8434
252
-5135
-7371
1260
-7737
-4706
5971
5357
-9060
-1083
379
2385
-339
-4414
9017
6910
-7196
1217
-824
273
5463
5559
-7189
-8664
-5487
7254
-1767
-2941
6077
739
-2702
-6245
-794
-6572
-3387
-3029
6731
-9722
-1086
3333
7337
-9469
-1681
-884
9489
-6908
6628
-5439
1132
70
6104
-5569
2202
-9579
-3447
-7315
-6733
-7815
7375
4445
8666
8777
-423
-2426
9123
9609
8254
-8320
-513
9540
7587
-8312
6444
7654
-6913
8465
9688
8178
-8955
-1776
-1399
2504
-728
7972
-4695
-6427
2080
-4441
6161
8298
2765
-4850
-5635
-1383
-3747
-3581
-8119
-2037
5578
4463
6109
6289
-8935
-5043
4958
8610
-4327
5798
-7718
-5962
9214
-644
-787
2962
6006
1251
8760
3876
2124
3611
7339
-5208
-2834
8933
-7751
-7999
4574
365
-7823
8849
-1299
-3740
5580
8341
3171
-4984
148
8493
-2708
-9483
5728
1942
-4819
678
9274
-3488
5923
7368
2023
1121
7268
-8014
-348
-2952
-1682
8497
-9032
-9324
-5511
8786
9173
8183
6424
5311
5873
9864
-5636
-4282
6683
-7379
-2818
3646
-6270
-7315
-7164
7680
-7638
-9566
-1579
2746
-2415
4114
1960
2996
-7061
7016
1580
1046
8705
-1799
-3681
-893
-2467
6067
2484
6164
4421
-5535
-309
8989
-2971
-5852
-3304
4394
-8987
-9771
-3726
-9503
419
-1333
-9528
-3726
178
-7032
-653
8762
-4591
4205
-9779
-7503
-5624
-9338
-695
1351
-5491
-4721
1744
-8521
-8144
7862
-6212
2119
-3660
-5105
-2342
-2656
-3429
6484
9201
-638
-555
6491
-5740
5142
8014
-6502
-1776
-1676
440
-3196
689
3034
416
-7914
-7849
-6762
6311
-7093
4620
-5655
353
-7631
-607
-3002
-2091
-2200
7944
3227
1311
-2778
-4670
4779
-9250
4502
5435
2132
7095
5264
227
-8325
-3353
-896
-4108
455
8982
3803
-4455
6833
-6719
-8471
-6918
3602
-2964
8786
-9781
416
9282
-544
-7060
7146
6150
68
5116
-7236
-1162
-7896
2403
5943
-5317
-8209
8013
4672
-4835
-116
5598
-4151
-8342
5495
-5005
7465
6420
-7272
-6323
-8079
2957
9142
4985
-9717
5529
6395
6850
7375
3603
7807
-7979
-989
-471
-4042
9595
-4754
1491
-1563
-9274
3214
-1355
-2194
3555
-6280
-8809
-30
-8901
-8986
2053
-8746
-2708
2786
-6527
-9214
4062
-8801
-4445
828
-7455
-883
6937
4021
-4703
-8094
928
-5725
-3269
128
550
-6455
4641
-520
-2263
2656
1503
-4993
5331
-8646
8814
-4954
-4441
-1230
-8628
4853
-9148
-980
5520
-6885
5957
-7023
-6484
6733
719
-5795
-9895
3926
8024
3415
1822
-4039
-915
5038
-7780
9632
-526
985
2155
-5564
-245
-8940
-1504
1143
-5463
6741
-3549
-2333
4159
6609
8449
-6050
5795
-3203
-2003
6940
3597
-749
124
-5624
-5310
-2710
-3650
-4143
4322
3336
7428
1210
-3049
2307
8555
5340
-2309
4221
-3512
1090
7523
6550
9949
77
4866
-9575
-1920
3941
2746
-4263
81
1987
3091
1269
903
2080
-1062
7222
-794
-5795
5190
6972
9963
-2341
3480
7766
-3409
9968
8080
-1676
1292
1062
6490
-7408
-4989
-3363
4641
-1735
3460
-9794
275
-3387
-84
7606
1033
9947
-1323
5620
4035
4431
7872
1304
8183
7821
3004
-7634
-7406
-5971
274
6918
9031
1371
-1939
2520
-5185
6285
-8759
-9714
5710
816
-632
1814
9031
-7059
-9611
7417
-3360
7321
-7811
-9561
-7104
6000
5762
-6425
-8697
5914
433
4502
-1135
-2779
-5260
-9558
7687
-2295
9139
-2115
8659
8774
-1008
2765
-1907
2817
-9885
-116
-914
-1394
-3936
-6160
-7122
4641
-9100
-1340
-8514
-1312
1966
2023
8083
-9096
-2884
606
1739
6299
5090
1791
5329
1705
-6015
7262
4331
-5193
5983
9532
7392
5177
-2599
9314
-3932
-665
8016
6006
-4512
-6538
-487
-2529
-8531
-7131
-9342
2600
-8490
4272
7782
4413
9710
-5893
1530
8464
3481
-1416
3254
7019
-9199
-5684
977
-3241
-5687
-5111
7949
-4470
-8883
7983
-787
3617
6651
8908
-3068
-4367
3501
4027
-5569
4835
-9485
4216
2318
590
5920
3616
-2761
-1070
1685
-2121
-910
8609
6396
403
1338
-1370
798
-6555
-7816
8142
6037
-4094
-9898
-2965
4239
3024
-5956
-752
-5043
215
-3050
-6040
5963
2107
-4523
-9981
4784
-7715
7507
2949
-1959
1504
9339
-9843
-8688
-1124
6685
9380
1367
6109
-1174
6005
-7995
-1077
7718
-8331
-4375
-1793
-342
-8121
-7765
-7503
7030
7460
-3330
-9566
1027
2445
2811
6863
6564
-4355
-4590
-3747
-6372
2643
-9772
2613
-3835
-3582
-1381
8848
5715
7920
3366
-9199
-1060
5291
8313
-2965
2709
7679
-370
6749
-4559
-1787
-3670
-9813
5335
-1428
993
253
702
-8604
9833
-4450
3006
8950
-6719
-2407
-8659
394
-5193
-5135
-300
1028
5118
2353
-1076
9654
-3903
-1460
6609
-1351
9142
666
3941
846
-4867
8183
-8078
-4174
-9761
153
1698
8672
2015
-3623
7922
-5083
-4295
6352
-8346
-5628
2106
8600
-4512
49
-7778
-9106
-8437
-4375
-6930
-422
-2933
-5445
-357
-8841
-7110
1487
-4917
-1954
-7190
-8787
-1982
1888
7543
6307
669
-9842
-8664
-4501
-8455
-3715
-6427
4529
7831
-7515
7213
-88
-4070
7471
4092
-3247
-8082
1790
-8623
8620
4802
2702
-2083
8624
9066
6
-6333
6550
3171
-1024
-8745
-591
8726
6507
-2328
4381
1354
6508
-9730
2951
3855
5598
-9783
630
-4862
6491
-6572
8372
-476
7950
9136
-1316
-6824
-6127
9918
-1964
-2394
4429
7048
-8252
-8727
-2713
-4422
-8098
7497
-9122
5842
8636
-4193
-2068
-7196
-1803
8311
-6325
436
4824
9583
6326
-303
4465
5529
363
-7622
-7861
6819
-9159
-1410
-7252
291
3328
-3066
-5999
2931
7752
7831
9817
4600
6131
1788
-5316
1896
-4133
1722
-2915
-8969
-6588
-755
-9767
66
-9227
7470
4569
7150
-6078
456
875
6165
5160
-2902
-8059
4618
2873
-752
-8618
-6859
-9750
4433
-112
1913
-7342
-5930
-3050
-4009
3668
-4559
9534
675
1506
5160
2640
-1482
-7613
4959
-4341
5583
-4856
2598
-7695
2490
2326
-7397
5891
3973
8177
908
-4048
-5273
3430
-3243
6399
8901
5896
4222
6403
3088
2351
-5193
5715
-3904
-5638
-7291
-2406
-4420
-937
2718
-5892
2530
1175
4107
9274
531
-4045
3024
3941
-6060
886
255
9567
-7411
-1148
983
-5777
-9149
3828
2786
-6136
-4984
8828
2681
5458
3532
9179
-1162
2645
-7675
-2958
-321
-8819
1018
-5731
2669
-5322
3871
6846
5607
-5095
5870
-7389
5049
-9884
5132
8212
-1065
6971
6635
4634
-6468
8390
7076
8529
-490
9595
7832
3931
-3978
-4244
-1797
4043
-4739
6158
-7853
-7557
7760
1903
-6035
5278
-5677
-7828
-8932
518
-5349
-5721
6371
-4771
336
8022
-8946
-1294
-627
-4398
5715
1838
720
-4491
2108
-7595
-6050
7528
8606
5495
-4741
-3686
-4748
-9307
6407
1425
6345
9777
8551
7485
1698
8087
-1243
1762
8259
1097
8224
-9779
-58
-17
8299
1385
1908
-260
6584
-3141
-3326
1029
-5246
5768
7045
6093
6326
8091
-457
-5791
4123
-3096
9476
-5418
3375
-90
-5850
4293
-3723
-1849
-6054
4110
6771
-2529
520
-6594
-4321
3446
5795
4088
-9859
-8033
-8574
9466
-290
-8344
-2520
985
5529
-4985
2700
-3488
9908
7145
-826
-2182
-2655
3418
6192
-805
1784
-9928
-3858
-2580
-2222
-8437
2858
4221
4606
-2231
-1280
1153
9585
-4028
-6169
6205
-4904
-9127
-7408
9311
1976
9952
9135
5160
4864
3507
-8800
7099
-4502
66
-7695
310
310
5707
-2300
-9912
5402
5733
3515
8351
-2876
2802
310
-5552
7385
-2799
6830
-8974
-1423
4664
7303
-6868
-13
196
-7378
3373
5098
-9619
-1762
-9620
6260
8826
636
4293
7373
-9500
8588
-4683
7724
-1799
-5815
4853
7797
416
4328
5007
2883
-5348
-3037
-3394
7463
8495
-9891
-3143
3970
3557
2765
-5348
-6743
9694
535
1399
3279
3393
1413
4244
3137
-2979
3682
2726
-1830
-6599
5883
-1268
-4339
5385
4790
-243
9570
4433
1464
4027
3462
9803
5559
-9772
1685
-2834
148
-4404
-6484
-6930
-6567
2663
9139
-6486
-3202
-7788
-1645
1398
-6288
-5212
-9685
-8044
-7743
-7439
-8773
-8779
-627
-425
-8881
-8936
-8974
-8214
2969
1492
9727
485
-786
-7388
7402
927
-4640
8609
8838
-4074
-2857
-544
-6003
-866
7862
9507
-958
3077
-8050
7597
-6325
2644
-2520
-3621
-9982
6960
439
1291
-889
1553
252
-1056
-6925
508
3159
-2087
-7038
3375
-3409
5091
-1585
-3971
7333
9012
9431
1526
3189
-8690
6223
7800
3607
-4375
5665
-2167
1437
-6357
3412
1718
-4075
5768
8644
6000
-8168
-9070
7634
-7391
9316
-995
-8787
-9005
-5175
-8964
3198
7592
-1391
-5365
-5203
-2857
-1148
1580
7767
4456
-4222
8190
5738
8801
9466
6385
-1011
-1524
-8210
-3124
-1056
-5845
-9227
2169
7994
-4414
-4558
1371
1875
2718
-6249
4309
-3330
-1821
8950
-9802
1775
-4601
6899
-5125
-168
2338
4704
-3675
-4068
-3850
9055
-738
8235
899
-3907
-5852
-853
-1288
-4813
8028
-6427
-7729
5557
-4615
-5132
-3850
2811
8458
3198
1267
9788
-9206
9952
6818
44
4911
5360
-5434
4214
502
-8200
2126
-7718
-6487
2817
4215
-2635
8435
7835
9444
-6240
-2818
-8320
-5316
8332
2532
9300
-1612
9695
8917
8578
-4347
-7133
-5841
-8490
1756
5020
1761
-2557
-2424
8014
-6768
-9319
-9181
8859
-1874
3442
180
2149
9011
3565
-6494
3494
-30
4807
-8940
4192
-1291
4608
5858
-7131
2195
-7381
-1591
-5527
-755
-9951
3023
1045
-710
-8521
-3619
8016
-9860
1338
7926
2724
6410
4912
8159
-5603
4250
4107
8655
7761
-7562
-3245
6488
-4191
9513
6995
885
2597
-7642
9860
-249
-5907
8063
-8135
875
1021
-4819
7657
-5526
-3073
4608
-7283
5595
1017
-5351
-375
8666
-2645
7797
-5034
9845
6614
-3771
7329
661
-6574
8449
475
-1253
2066
6514
-3228
5190
548
-5290
-2708
617
4994
7379
4659
6283
-6389
-522
358
-4202
2338
8979
5136
-1120
-8881
-8997
7482
-9578
-2185
-5311
-6484
-402
7029
6042
8019
7237
-1652
5271
581
-4198
-8144
7238
-8401
4340
-880
7516
200
-570
4735
8970
-3503
2136
-249
-1336
2881
1153
2779
-6502
-5357
-4344
-9367
5213
5140
3904
3892
-1524
-9854
1867
7971
-3123
-1430
2435
1332
3037
-9619
3349
7570
-5208
-4340
3075
2881
-7029
-7318
-8881
-2793
7683
502
7438
-58
2242
3713
-8210
-9956
-2729
7715
-657
-6804
5640
3768
7891
-553
1796
5184
-2769
6887
3010
-1731
-2185
-8569
-763
-6519
-743
7968
-487
-8264
-5191
903
9968
-1499
-4609
420
1311
5265
-8482
-7728
-575
-3861
3367
5751
4235
-6552
-3715
-6163
9171
2212
-7106
2149
-468
3592
321
-2778
871
-648
4112
-7163
8400
-814
-4078
-6084
6406
-7732
-7251
9730
-915
-3508
-3782
-7836
2169
-8325
-8089
-7683
-6552
2213
3871
9119
789
-5708
6164
-6934
-9097
-5698
1245
-8836
-2601
-1340
-7682
7184
839
8029
0
7940
7203
7713
-3739
6186
-3488
7561
3348
-9885
-3624
9827
-8653
8795
1711
-1268
-4012
-644
5025
2159
3297
4522
-1830
-2208
-910
-4419
4864
-9292
9779
8019
7561
4109
4112
766
7606
-4713
8082
280
-6494
-6419
6724
-9740
-1730
-402
-3107
7294
-4619
6430
2030
715
-3747
8651
-6640
8231
1109
-6438
5043
-3393
-4081
-2228
-6050
6683
5182
-4071
1977
7237
-6137
4586
-4594
-6389
3275
7226
-1499
-4045
-710
-1717
2004
-9233
711
-312
6121
8074
-8729
6942
9186
8126
-6851
605
3014
-7272
2492
7352
-8964
-3374
-5469
-4071
1445
6952
-120
-6443
957
26
-6614
132
7766
-5892
7077
8417
-1274
-5682
3359
-7519
-5409
6246
-4105
-5232
-1240
3936
-7830
281
263
-8174
1626
-6487
-3574
-3063
-70
7360
3718
8576
-880
5961
-6383
659
9326
-2108
-6844
-9557
2723
661
6066
1447
4112
3103
-3201
8024
-1940
-8089
-4348
-9905
-5650
-3786
5939
439
-5183
3557
1290
9713
3882
5122
-8181
-9490
6917
828
-635
-5957
-3845
1268
-9589
4501
-595
-3264
-7198
5106
4323
-7543
7689
-8970
-4304
-8142
1833
-2222
1021
4313
8003
6678
-2685
-3505
4503
-9031
-1062
7880
2269
-1806
4053
2452
-757
6604
7975
-4095
9784
2041
3858
-625
-106
10000
3098
-7861
-5260
-7284
4707
9684
-1086
3485
-1820
-1114
-3689
8112
537
7146
-3371
4655
7103
7777
-3508
-3720
9883
1870
-3158
-3112
-8082
-5102
530
-8855
-1707
6959
9828
7208
-8533
3605
6615
8892
9480
-319
-2068
9994
-8653
-797
-7497
-1510
-88
-5505
3164
-1665
1643
-7521
-170
-18
4591
-6405
7627
-2199
-2682
4851
-1826
1988
6733
-1488
681
9013
4583
9757
6749
-2183
7832
5190
-4717
-7511
-6974
2863
9489
-8034
7215
2973
7438
6850
4601
-8758
5113
-9804
7738
1476
6622
6416
548
-4989
-6299
-1549
7365
3358
1429
3227
-3080
-4838
-7490
-8758
-8569
4689
9153
7277
1873
-3349
378
-3068
-1015
6929
-409
4478
-1431
-9115
2523
512
7170
-7416
1873
8933
1260
-6290
-7083
7846
7626
-9974
324
4583
8970
2155
2621
3161
-5990
-5155
-2895
213
-4326
7025
-8275
5971
1487
3601
-9644
-9110
-9212
-7413
6256
-7758
2948
-1957
-7160
-3196
160
2202
-4843
6221
-7859
1880
1418
-7914
-6236
-8650
-4166
1057
9353
-1826
3539
-2981
2889
-5076
-1360
8499
-4441
3516
-9611
-4357
-8974
2191
1564
-4339
-7936
6742
"""

}
