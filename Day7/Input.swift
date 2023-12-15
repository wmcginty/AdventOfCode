//
//  Input.swift
//  Day7
//
//  Created by Will McGinty on 12/24/22.
//

import Foundation

extension String {

    static let testInput = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

    static let input = """
    QAAQT 665
    5K355 312
    Q5T46 440
    A3AJA 461
    QQ9KQ 825
    QJJQQ 51
    7J7A5 37
    8J887 774
    AK3K4 62
    A399A 110
    75845 946
    KAAAA 226
    J9976 869
    627Q8 917
    K2252 216
    A44AA 867
    2TT39 160
    65566 225
    K6KK6 655
    42T34 787
    T6636 347
    QTQTT 371
    83T33 878
    Q9928 742
    JQ85Q 423
    JQJQ2 654
    63TA5 645
    TQ8JQ 884
    T44T4 6
    5J523 83
    87Q42 527
    3J7A7 530
    K99KT 158
    326A7 546
    T2AQ2 8
    99JAA 464
    QQQ9T 988
    J6466 568
    4Q9Q5 182
    J89TJ 63
    66J55 870
    Q35QQ 1
    2K637 46
    T76T8 280
    9A9QA 634
    Q6AAA 486
    88986 350
    4J266 875
    JJ666 116
    38338 422
    A72KQ 799
    A26Q7 666
    33434 788
    32845 457
    9A36A 995
    328Q2 77
    KQ688 238
    5885T 455
    52822 145
    32555 125
    85557 574
    34422 790
    KJ777 428
    JJ777 122
    26852 914
    TKAQ5 819
    374QK 918
    Q365T 462
    62359 179
    J22QJ 367
    55655 641
    JTK4J 679
    K3KK5 711
    A2353 688
    5556J 40
    QQQ79 167
    8K38K 676
    KJJ6J 61
    AA5JA 544
    KKK7K 375
    3Q7QQ 775
    22K88 71
    55KKJ 101
    5J55J 982
    AJTTT 541
    T84KT 343
    T77TA 162
    AT296 31
    T7AJ7 334
    K3K44 310
    TT49A 281
    27648 18
    34449 156
    49489 763
    42924 672
    85886 118
    J6793 800
    5878K 659
    8J26J 21
    384Q3 822
    AAJJJ 949
    77262 643
    66545 411
    24J8Q 520
    TTTT9 314
    7JA7A 473
    2QQJQ 335
    J88KK 721
    32223 251
    J222Q 403
    8J8AA 277
    39QJ6 187
    3Q99J 830
    Q8TT5 240
    J22KK 519
    4J4JQ 928
    7774J 239
    85535 415
    Q38Q9 171
    T8833 588
    3367A 781
    62224 100
    3J8T8 210
    48J88 834
    6Q66Q 301
    3A6K6 586
    2A3K2 419
    83T62 712
    7JJ49 82
    JQ798 66
    97947 921
    A478A 223
    25QA7 602
    3KJ96 729
    KK33K 543
    44Q74 386
    5A635 753
    K33AK 400
    QJ666 756
    QAK7K 564
    J8AKA 682
    28A6T 887
    8AAT7 191
    T6587 612
    JJJ22 430
    55A5A 303
    TT388 976
    33A33 388
    KKAJA 933
    KK852 922
    QTTTT 333
    4T5J4 509
    T99TT 394
    977TJ 785
    88222 862
    442J2 719
    74234 138
    J5KJ8 909
    J6JAA 341
    TQQ4J 381
    55585 111
    T7Q7J 396
    53T65 562
    9K7KK 220
    57J79 356
    KA74Q 687
    JQ687 662
    62A5K 326
    9TTQ9 163
    59595 49
    JKJKK 727
    37369 539
    JAJAA 68
    9KQ43 477
    46J4J 945
    39333 701
    38J65 767
    K93JA 941
    75725 529
    97K9K 615
    26AAK 579
    6A565 420
    5T555 650
    AA788 87
    K2799 969
    TTJQT 185
    K88KK 515
    37Q87 495
    T65QQ 275
    4QQ53 638
    68662 758
    42288 731
    36Q66 789
    JAAA8 924
    J2K77 443
    82Q82 569
    66T6A 476
    TTKTK 108
    74444 993
    J5555 658
    T89J9 38
    23332 246
    K4982 279
    KK4KT 501
    44454 233
    QT398 866
    4447T 432
    4T944 939
    2T828 549
    266TT 72
    99929 814
    49632 256
    4499J 124
    Q5QJ4 573
    48664 175
    76A8J 795
    Q82TJ 245
    JQ39K 336
    57297 689
    33KJJ 959
    64T4T 534
    63636 809
    688T8 583
    84J34 35
    4TJQJ 94
    399QQ 479
    99996 577
    76633 13
    A3AK8 298
    AAA22 697
    88J8T 19
    44Q3Q 610
    99J99 315
    88843 636
    2AAAJ 953
    53535 603
    47AK6 811
    AA65A 642
    K2QA9 902
    34K8A 748
    JA738 611
    7A777 829
    Q6Q77 559
    QQJQQ 991
    23222 368
    755A5 536
    7A987 177
    Q47K8 624
    69666 705
    KK233 329
    J9J44 450
    J22J2 670
    A55JA 926
    229K2 827
    T8A36 237
    22526 490
    KKK5K 75
    9729J 693
    9K829 609
    T293Q 796
    J8A44 931
    K9J46 441
    75776 149
    6KJK2 675
    TT7QT 507
    27K2J 533
    72444 764
    4QA89 990
    A5238 754
    K5335 152
    2K372 132
    37J73 328
    A7TQ9 965
    2T22T 484
    66T4T 199
    3K333 337
    9854K 20
    TAAQ2 103
    A44T6 81
    7262J 510
    K92AJ 983
    827A5 614
    23773 980
    9Q524 166
    333JJ 463
    AA4JQ 911
    QQ282 313
    9K75A 873
    9Q484 332
    Q7J77 114
    TATKA 218
    2TTTT 798
    3Q335 966
    33QJQ 212
    4Q55A 901
    947A9 736
    92J48 465
    4TTKJ 50
    8J898 604
    2TJ52 840
    Q9JJ8 813
    7KQQ4 958
    55453 282
    4AAAJ 183
    5998J 65
    597JJ 480
    QQQQ3 207
    Q78KJ 720
    J9993 331
    K7J57 677
    J8868 597
    36238 770
    48K28 517
    K57T7 43
    7K737 305
    22J22 553
    32J22 691
    A3K86 259
    J6A6Q 135
    5QAQA 164
    A2J2A 595
    9K3Q3 557
    J3J9J 552
    83222 703
    9Q9JQ 113
    T676J 823
    K4446 85
    TQJK6 250
    T6KTQ 376
    6AKT5 294
    7AA22 243
    26QJQ 398
    K4T28 141
    T58KA 73
    J5Q4K 47
    AAA59 652
    QA4K9 622
    T888T 967
    7375J 726
    AKA5A 14
    A3A5Q 894
    88588 7
    94664 354
    T9926 29
    54JJJ 776
    AQ3K9 752
    J8TT8 105
    65TA8 421
    99966 269
    92JKT 296
    KKKK4 673
    2JQ2T 832
    KAKK9 262
    992J3 554
    66868 700
    AA2AA 351
    Q4743 851
    34394 355
    T6T69 732
    TA549 155
    QQ99Q 300
    33QKJ 555
    A4444 833
    3KJK3 563
    65A78 831
    KAKK8 744
    5QQKQ 985
    5754J 769
    666JA 414
    TKKKK 23
    93K5J 837
    85558 78
    K6286 663
    T8K58 735
    56JAA 224
    4T94T 345
    63333 172
    58356 853
    666TK 30
    A77AQ 896
    68QA8 174
    924KA 292
    92TJ2 898
    J5859 230
    QTTT6 319
    AAJAA 860
    28A4Q 714
    K274T 671
    73337 28
    979JT 899
    8KKKK 740
    4Q99Q 944
    KKKJ7 718
    Q7JQQ 438
    73K3T 999
    5J25J 379
    5999A 416
    T9922 265
    7K485 648
    3A57K 686
    777J8 695
    KT999 274
    2554Q 500
    T2226 284
    Q8QQQ 302
    KJK9K 556
    53A99 52
    768K3 488
    55JA5 115
    K3K77 986
    77KJK 804
    86585 390
    39699 469
    TTT53 859
    26266 628
    87858 200
    J9Q7K 359
    J8AQ4 377
    3998Q 76
    99994 161
    3587J 728
    K9K33 816
    J8Q8J 456
    894J9 733
    T4J65 514
    72767 613
    5T8K2 370
    KAKA6 855
    A3QJ3 738
    JQ537 504
    83323 271
    KK667 558
    QKQ8Q 908
    4TAAA 34
    35Q95 625
    T9777 323
    66664 9
    99A66 631
    888JA 244
    J745Q 635
    ATJ4T 107
    49KQ7 757
    95999 242
    4A422 560
    6QJ2A 854
    77288 646
    6TTJ6 989
    T777T 524
    34A34 22
    3A362 295
    66967 528
    J77K3 297
    22T7K 485
    33J34 904
    83J38 287
    98KA2 372
    74Q6A 221
    KKK55 348
    QQ222 838
    7TTQ5 342
    KKK9K 640
    22922 405
    QQQTQ 633
    98T87 912
    55357 449
    92333 198
    76777 470
    48JTK 849
    J9779 321
    95557 64
    J9299 605
    2JQK2 578
    36634 44
    TTKKJ 90
    T4666 190
    TA7K4 364
    8T85A 330
    J92J2 717
    22945 606
    756K6 561
    8632K 452
    747KK 365
    T68J6 195
    JA454 587
    QK849 793
    594J8 812
    92559 970
    89829 130
    Q6849 571
    4TA4T 996
    TQ24Q 846
    T8T3T 792
    AA5A7 338
    553A8 325
    KK95J 566
    Q4443 734
    T923K 512
    939Q9 716
    K3TJ3 864
    5T9J2 590
    22522 644
    88444 778
    97779 475
    5AJK5 548
    344A4 618
    TT252 508
    6T359 466
    2AA2Q 446
    TAATA 916
    6K6KJ 954
    4AAK5 255
    T433T 952
    299K6 389
    33343 399
    QJAAA 98
    JQ3Q9 601
    39999 521
    8A3J3 847
    99339 791
    JTJTT 661
    9AKQT 451
    5Q5K5 651
    42242 955
    Q2266 794
    5JJK7 227
    QQKJ6 454
    TJ9T9 15
    K4K46 254
    Q9KKK 213
    Q8844 786
    8922K 998
    J877J 617
    77929 412
    J8A66 531
    555TT 513
    K6Q49 268
    64464 801
    99JJ9 523
    626A7 709
    7AQQQ 835
    66AA6 938
    88T56 667
    KKKJ4 960
    48999 503
    4494J 496
    K883J 391
    2KK99 119
    7737A 270
    KQJ69 550
    33KA8 723
    T3JT9 893
    99899 444
    T847J 134
    J9694 616
    55AAQ 1000
    3742T 660
    44QK4 940
    7777K 773
    TTT5T 923
    JKJKJ 150
    9KK99 649
    AJ546 2
    A999A 694
    KA4A6 828
    9AJA4 168
    555Q5 353
    64J46 426
    55KTA 327
    86688 747
    J8883 905
    2JQ2Q 460
    59826 120
    T843K 600
    52252 32
    Q62J9 576
    38777 684
    3T433 418
    4J4AA 772
    QQKJJ 621
    A9637 815
    99JK3 74
    35J99 349
    98334 402
    86K42 215
    T8J3A 930
    89A38 627
    8JJ87 730
    T6256 664
    68445 264
    47673 858
    AT28A 803
    8KQ28 392
    33JK3 425
    53999 11
    68TJ8 59
    7K7K7 241
    64379 383
    K3TQ4 581
    T5Q88 593
    77474 60
    887JA 252
    44446 852
    J9393 971
    8A633 492
    74479 589
    2Q555 565
    8J888 407
    97Q5A 178
    48632 16
    4K6QT 805
    3Q333 106
    T36J3 17
    AAKKK 981
    AAJQQ 194
    9Q393 584
    JTKK9 505
    J986K 3
    55KJ5 285
    8K882 920
    8KA82 232
    9AAA9 656
    22J92 630
    QQQQA 522
    7A652 25
    T4665 591
    T7TAT 447
    87KK7 762
    QT967 493
    Q3QJ6 580
    A8T6T 180
    88J58 843
    KKKTQ 957
    45K2K 380
    22343 749
    K8T88 963
    3T4QJ 48
    T59AQ 136
    QKKQJ 487
    353J5 283
    4J8Q5 936
    7747A 844
    52562 992
    6JJ64 888
    8Q33J 102
    K86A4 373
    747A9 572
    JA22Q 184
    79333 236
    9Q65K 532
    4J677 234
    A2J74 154
    92339 4
    J3337 751
    67A5T 248
    A8AAA 339
    37K3K 413
    43337 678
    93QQ3 69
    5KQJK 346
    T9T99 324
    66T66 802
    3T792 79
    57575 231
    J47JT 715
    62666 657
    997K9 128
    32TK7 253
    96294 877
    63666 5
    KK397 408
    4A4J4 97
    Q4265 146
    AKJAA 948
    J5Q94 263
    ATTTT 575
    4827T 133
    47AK9 683
    68T47 567
    2QK28 445
    T22JT 607
    662QQ 181
    QQ6QQ 153
    92292 582
    96K9J 173
    2J299 404
    T333T 273
    25J55 362
    6AJ2T 929
    5K323 710
    9944K 453
    A9Q49 755
    TTQ5T 962
    444Q4 311
    76666 176
    9946K 690
    KK3QJ 471
    ATTT6 247
    2A2K8 112
    A4T9Q 692
    777J7 839
    595J4 206
    TAATT 629
    53333 883
    A59T6 707
    44525 906
    Q8J8Q 137
    T3J93 696
    47464 340
    J2822 907
    JJ559 196
    55343 653
    9K9Q9 674
    8TQQQ 211
    7J275 70
    22Q5J 276
    66564 129
    TJTJJ 489
    KK6KK 409
    5Q98A 157
    78777 857
    67667 807
    5QK98 39
    K35J6 592
    96KT2 109
    4KK44 127
    T6253 768
    85989 836
    55445 299
    T9736 121
    A696A 950
    T48QT 668
    644K6 518
    JJJJJ 876
    TQ6AT 759
    KK83K 260
    73777 214
    6K66Q 598
    5K39A 169
    64T7T 219
    238J2 442
    4J22Q 203
    Q9TA6 291
    5T86J 26
    T439K 272
    44244 817
    K8844 459
    K5KK7 975
    A666Q 842
    8T6Q7 434
    63Q4J 42
    966J9 637
    JA6KA 863
    A5555 972
    T2222 745
    AAA7A 499
    Q359T 436
    A2A5A 879
    QQQQ5 623
    K4T5T 724
    A888A 987
    5J535 201
    5A9K6 123
    4QJ43 431
    75J4J 491
    283J8 698
    T7T8T 448
    33J76 197
    47QJA 24
    2T272 951
    A7A87 142
    J3TT3 540
    4JJ44 961
    KJJ63 478
    92QQ9 278
    TJTTT 192
    TJK68 307
    37773 290
    QQQT6 126
    QJQ9Q 401
    24K3A 186
    8443Q 820
    33592 56
    87923 497
    TTJ8Q 632
    J4544 934
    6K666 474
    68566 739
    A4AAA 669
    89899 139
    842K3 596
    K5AA5 429
    85885 599
    59779 437
    A336J 779
    TT3A3 366
    97Q7A 261
    83393 545
    Q6Q6T 974
    37T2J 890
    38333 58
    28227 363
    TTT66 33
    32333 468
    A8T55 824
    88889 435
    KQQ3Q 385
    T6685 318
    5K76J 202
    75777 99
    53566 55
    TTKJT 481
    875J9 551
    447A7 947
    T2TT7 147
    T2726 810
    TT6TT 856
    QK9JQ 27
    A786Q 897
    44J44 542
    98QJ3 189
    J4448 89
    Q8Q8Q 417
    59473 57
    99K99 148
    662AJ 361
    7TTTT 994
    26T97 36
    7A69T 746
    95JA5 516
    J9J8K 886
    57333 358
    4TJQA 881
    T5628 151
    72A59 205
    QK777 249
    84649 397
    T7T96 761
    4TAQQ 378
    24274 494
    KJ3KK 845
    TT77T 384
    8J88J 722
    A25T4 880
    88868 861
    Q5QK2 502
    35344 267
    K99AA 777
    2T375 903
    4484Q 891
    J8AQA 67
    QJ578 935
    T72T7 482
    5AQK8 973
    T3AA9 848
    8TJJ7 165
    88J75 322
    T8T8A 54
    93524 956
    29T9Q 458
    66272 647
    TQTQQ 681
    629J4 483
    6676T 708
    9QT99 704
    67977 942
    737J7 808
    T785K 865
    7AAA4 943
    88Q8J 619
    QK663 91
    9734J 818
    J4TTT 895
    5A585 80
    8JJJJ 159
    7T298 170
    8998A 140
    TT5T2 266
    44443 53
    57565 439
    T579A 317
    A5QAA 235
    A665A 84
    223J3 766
    T63AJ 741
    62K97 760
    Q8Q33 538
    A5955 293
    JKKKK 86
    88228 10
    376J7 93
    7343T 535
    KQK44 882
    KKK76 395
    9229K 526
    J63J8 320
    ATKKK 104
    T4JT4 850
    79A9A 780
    AA6A3 387
    6A542 889
    45242 228
    KJ75Q 369
    52T29 41
    A9924 309
    A7838 925
    2738J 229
    22262 782
    A55AA 144
    77727 88
    86556 188
    46443 997
    666J6 900
    99968 12
    9AA49 927
    68666 467
    52K68 750
    3J339 498
    43634 304
    TJK46 585
    43533 511
    55245 537
    39K3J 765
    65J54 937
    5T684 594
    22Q74 868
    25255 871
    5TTJ5 797
    93J7A 784
    AAAQ8 357
    7J727 968
    44T44 821
    77533 608
    KQQ83 547
    72222 680
    44A4A 406
    8932K 222
    KK59K 874
    774K4 92
    29992 570
    3333J 620
    39393 506
    74773 892
    T79Q8 208
    TTT3T 885
    QQQ8A 374
    99979 360
    2965T 872
    AA6AJ 96
    383K9 826
    7TK7K 685
    6J755 979
    2QQQ2 706
    TTT4T 525
    3K767 699
    75J8J 639
    KTJK3 743
    7972T 308
    77573 143
    J253K 286
    TQK85 316
    6235A 193
    338TT 393
    JT8T5 352
    JA4JA 984
    JAQ86 737
    9T589 306
    KJQQQ 424
    JJKTK 964
    QTJTQ 783
    6J626 289
    24Q22 131
    QAT5A 919
    6486K 702
    QT464 288
    A6972 841
    Q99Q9 977
    4JJ43 209
    66AA8 910
    Q34QT 806
    Q8J4Q 472
    979TT 932
    A8A8A 204
    9A34Q 382
    QT89A 713
    JQJJQ 427
    8338K 978
    99T99 913
    6A444 257
    4K5KK 45
    55K55 217
    K8866 915
    42577 771
    45564 725
    Q2TAQ 433
    Q9AA6 258
    867A3 117
    A9799 95
    74778 344
    A2727 410
    78888 626
    """
}
