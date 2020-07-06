---

title: "Java系统学习017-排序算法(一)"
scp: 2020/2/6 23:35:40
tags: java,算法  

---

## 排序算法理解与代码

### 冒泡排序

**原理:** 相邻两个数据比较,每次找到小的放前面   
原始数据:{1,3,4,2,6,5,7,9,8}  
第一轮:{1,3,2,4,5,6,7,8,9}   
第二轮:{1,2,343,5,6,7,8,9}  
...  
代码:  
```
    public void bubbleSort(int[] a){
        int N=a.length;
        for (int i=0;i<N;i++){
            for(int j=0;j<N-i-1;j++){
                if(a[j+1]<a[j]){
                    int temp=a[j+1];
                    a[j+1]=a[j];
                    a[j]=temp;
                }
            }
        }
    }
```

### 插入排序
**原理:** 每次取一个数和排好序的比较,插入到合适位置  
原始数据:{1,3,4,2,6,5,7,9,8}  
第一轮:{1, 3, 4, 2, 6, 5, 7, 9, 8}  
第二轮:{1, 2, 3, 4, 6, 5, 7, 9, 8}  
...  
代码:

```
    public void insertSort(int[] a){
        int N=a.length;
        //第一个不动
        //第二次开始和前面的比较,遇到比自己小的就停下,插入,后面的数值后移,否则就保持放到最后
        for(int i=1;i<N;i++){
            int temp=a[i];
            for (int j=i-1;j>=0;j--){
                if(j==i-1&&temp>a[j]){
                    break;
                }else if (temp>a[j]){
                    a[j+1]=temp;
                    break;
                }
                a[j+1]=a[j];
            }
        }
    }
```

## 快速排序
**原理:** 取一个数为基数,比它小的放到左边,比他大的放到右边,之后再次递归处理  
代码
```
  public int[] quickSort(int [] a){
        //a={1,3,4,2,6,5,7,9,8};
        //用自己的思路,分成两个数组
        //ArrayList arrayList= new ArrayList();
        //取第一个为基数
        int temp=a[0];
        int N=a.length;
        if(N>2){
        int [] a1=new int[N];
        int [] a2=new int[N];
        int [] a3=new int[N];
        int n1=0;
        int n2=0;
        for(int i=0;i<N;i++){
            if(a[i]<=temp){
                a1[n1]=a[i];
                n1++;
            }
            if(a[i]>temp){
                a2[n2]=a[i];
                n2++;
            }
        }
        int [] z1=Arrays.copyOf(a1,n1);
        int [] z2=Arrays.copyOf(a2,n2);
        //合并
        System.arraycopy(quickSort(z1),0,a3,0,n1);
        System.arraycopy(quickSort(z2),0,a3,n1,n2);
        return a3;
        }else if (N==2){
            if(a[0]>a[1]){
                int temp1 =a[0];
                a[0]=a[1];
                a[1]=temp1;
            }
            return a;
        }else if(N==1){
            return a;
        }
        return a;
    }
```

### 希尔排序
**原理:** 插入排序对于大部分顺序规则的数据效率很高,希尔排序,先将数据预先处理好,最后插入排序  
代码  
```
   //希尔排序
    public void shellSort(int [] a){
        int N=a.length;
        int dk=N/2;
        while(dk>=1){
            insertSort(a,dk);
            dk=dk/2;
        }
    }
    //插入排序/希尔
    public void insertSort(int[] a,int dk){
        int N=a.length;
        //第一个不动
        //第二次开始和前面的比较,遇到比自己小的就停下,插入,后面的数值后移,否则就保持放到最后
        for(int i=0;i<N;i=i+dk){
            int temp=a[i];
            for (int j=i-dk;j>=0;j=j-dk){
                if(j==i-dk&&temp>a[j]){
                    break;
                }else if (temp>a[j]){
                    a[j+dk]=temp;
                    break;
                }
                a[j+dk]=a[j];
            }
        }
    }

```

### 归并排序
**原理:**每次分成左右两个数组,先把左右两个数组排好序,再合并,递归调用  
代码  

```
    public int [] mergeSort(int [] a){
        //每次分成左右两个数组,先把左右两个数组排好序,再合并
        int N=a.length;
        int mid=N/2;
        if (N >2) {
        int right=mid+1;
        int [] a1=Arrays.copyOf(a,mid);
        int [] a2=new int [N-mid];
        System.arraycopy(a,mid,a2,0,N-mid);
        return merge(mergeSort(a1), mergeSort(a2));
        }else if(N==2) {
            if(a[0]>a[1]){
                int temp=a[0];
                a[0]=a[1];
                a[1]=temp;
            }
        }else if (N==1){

        }
    return a;
    }
    public int [] merge(int []a1,int[] a2){
        //两个数组是已经排好序的
        int n1=a1.length;
        int n2=a2.length;
        int [] a=new int[n1+n2];
        int i=0,j=0,k=0;
        while (i<n1&&j<n2){
            if(a1[i]<a2[j]){
                a[k++]=a1[i++];
            }else {
                a[k++]=a2[j++];
            }
        }
        while (i<n1){
            a[k++]=a1[i++];
        }
        while (j<n2){
            a[k++]=a2[j++];
        }
        return a;
    }
```
