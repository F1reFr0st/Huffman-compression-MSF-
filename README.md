# Huffman-compression-MSF
### Code was developed for compression of **_grayscale_** speckle images. 
## Huffman encoder
The task is to create .bin files corresponding to speckle images with only one table of values and keys. Therefore, first, array consisting of average intensity values  of all images is created. In the next step with implementation of **_huffmanenco_** function .bin file is created and saved. Simultaniously, information about original image and compressed file sizes is displayed. Finally, when all data is compressed, total size of original and compressed files is displayed.
### Example

<img src="example%201.bmp" alt="example" width="200"/>

```console
1.bmp
Original image size: 1266 Kb
Compressed image size: 1137 Kb
Image size reduced to: 90% 
```

<img src="example%202.bmp" alt="example" width="400"/>

```console
1.bmp
Original image size: 8881 Kb
Compressed image size: 3213 Kb
Image size reduced to: 36% 
```

<img src="example%203.bmp" alt="example" width="200"/>

```console
1.bmp
Original image size: 856 Kb
Compressed image size: 719 Kb
Image size reduced to: 84% 
```
