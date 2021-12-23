---
title: sponge
tags:
  - sponge
copyright: true
comments: true
date: 2021-12-23 15:25:48
categories: 知识
top: 108
photos:
---

## 上传文件校验

```js
accept='.csv'
accept='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'

// * 从文件中读取文本
const readTextFromFile = (file: File): Promise<string> => {
  return new Promise(function (resolve, reject) {
    const reader = new FileReader()
    reader.readAsText(file)
    reader.onload = function (e: ProgressEvent<FileReader>) {
      resolve((e?.target?.result || '') as string)
    }
    reader.onerror = function (error) {
      reject(error)
    }
  })
}

// * 从文件中读取blob
const readFile = (): Promise<Blob | null> => {
	return new Promise((resolve, reject) => {
		let blob = null
		if (csvFile) {
			let reader = new FileReader()
			reader.readAsArrayBuffer(csvFile)
			reader.onload = (e: ProgressEvent<FileReader>) => {
				if (e.target && e.target.result) {
					if (typeof e.target.result === 'object') {
						blob = new Blob([e.target.result])
						resolve(blob)
					}
				}
			}
			reader.onerror = reject
		} else {
			resolve(null)
		}
	})
}
```
