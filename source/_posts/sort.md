---
title: 常见排序的JS实现
date: 2018-06-25 21:37:09
tags:
  - 排序
categories: JS
---

## https://github.com/damonare/Sorts 这位大兄弟 ♂ 总结的很好，快去看看吧！

<!-- more -->

## 冒泡排序(两两比较)

```js
function bubleSort(arr) {
  var len = arr.length;
  for (let outer = len; outer >= 2; outer--) {
    for (let inner = 0; inner <= outer - 1; inner++) {
      if (arr[inner] > arr[inner + 1]) {
        [arr[inner], arr[inner + 1]] = [arr[inner + 1], arr[inner]];
      }
    }
  }
  return arr;
}

// 推荐
function bubleSort(arr) {
  var nLength = arr.length;

  if (nLength < 2) {
    return arr;
  }

  for (var i = nLength - 1; i > 0; --i) {
    for (var j = 0; j < i; ++j) {
      if (arr[j] > arr[j + 1]) {
        var temp = arr[j];
        arr[j] = arr[j + 1];
        arr[j + 1] = temp;
      }
    }
  }
  return arr;
}
```

## 选择排序(遍历自身以外的元素，最小的元素和自己调换位置)

```js
// 推荐
function selectSort(arr) {
  var len = arr.length;
  for (let i = 0; i < len - 1; i++) {
    for (let j = i; j < len; j++) {
      if (arr[j] < arr[i]) {
        [arr[i], arr[j]] = [arr[j], arr[i]];
      }
    }
  }
  return arr;
}

function selectSort(arr) {
  var nLength = arr.length;
  if (nLength < 2) {
    return arr;
  }
  for (var i = 0; i < nLength; i++) {
    var index = i;
    for (var j = i + 1; j < nLength; j++) {
      if (arr[j] < arr[index]) {
        index = j;
      }
    }
    if (i !== index) {
      var temp = arr[i];
      arr[i] = arr[index];
      arr[index] = temp;
    }
  }
  return arr;
}
```

## 插入排序(将元素插入到已排序好的数组中)

```js
function insertSort(arr) {
  for (let i = 1; i < arr.length; i++) {
    // 外循环从1开始，默认arr[0]是有序段
    for (let j = i; j > 0; j--) {
      // j = i,将arr[j]依次插入有序段中
      if (arr[j] < arr[j - 1]) {
        [arr[j], arr[j - 1]] = [arr[j - 1], arr[j]];
      } else {
        break;
      }
    }
  }
  return arr;
}

function insertSort(arr) {
  var nLength = arr.length;
  if (nLength < 2) {
    return arr;
  }
  for (var i = 1; i < nLength; ++i) {
    var j = i,
      value = arr[i];
    while (j > 0 && arr[j - 1] > value) {
      arr[j] = arr[j - 1];
      --j;
    }
    if (j !== i) {
      arr[j] = value;
    }
  }
  return arr;
}
```

### 快速排序

- 选择基准值(base)，原数组长度减一(基准值)，使用 splice
- 循环原数组，小的放左边(left 数组)，大的放右边(right 数组);
- concat(left, base, right)
- 递归继续排序 left 与 right

```js
// let mid = arr[arr.length >>> 1]
function quickSort(arr) {
  if (arr.length <= 1) {
    return arr; //递归出口
  }
  var left = [],
    right = [],
    current = arr.splice(0, 1);
  for (let i = 0; i < arr.length; i++) {
    if (arr[i] < current) {
      left.push(arr[i]); //放在左边
    } else {
      right.push(arr[i]); //放在右边
    }
  }
  return quickSort(left).concat(current, quickSort(right));
}

function quickSort(arr) {
  var nLength = arr.length,
    pivotIndex = Math.floor(nLength / 2),
    pivot = arr.splice(pivotIndex, 1)[0],
    left = [],
    right = [];
  if (nLength < 2) {
    return arr;
  }
  for (var i = 0; i < arr.length; i++) {
    if (arr[i] < pivot) {
      left.push(arr[i]);
    } else {
      right.push(arr[i]);
    }
  }
  return arguments.callee(left).concat([pivot], arguments.callee(right));
}
```

### 希尔排序(不定步数的插入排序，插入排序)

> 插冒归基稳定，快选堆希不稳定

```js
function shellSort(arr) {
  var nLength = arr.length;
  if (nLength < 2) {
    return arr;
  }
  for (var step = nLength >> 1; step > 0; step >>= 1) {
    for (var i = 0; i < step; ++i) {
      for (var j = i + step; j < nLength; j += step) {
        var k = j,
          value = arr[j];
        while (k >= step && arr[k - step] > value) {
          arr[k] = arr[k - step];
          k -= step;
        }
        arr[k] = value;
      }
    }
  }
  return arr;
}
```

![sort](http://cdn.mydearest.cn/blog/images/sort.png)
