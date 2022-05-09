---
title: react源码解析系列三(React Fiber)
tags:
  - react
copyright: true
comments: true
date: 2020-11-23 10:20:28
categories: React
photos:
---

## Fiber

> 每一个 ReactElement 对应一个 Fiber 对象
>
> 记录节点的各种状态
>
> 串联整个应用形成的结构

例如：FiberRoot 的 current 指向 RootFiber 的 child ---->App 的 child ---> div 的 child---->input 的 sibling

属性：

```javascript
return; // 指向父节点（每个节点只会有一个父节点）

child; // 子节点

sibling; // 兄弟节点
```

### Update

> 用于记录组件状态的改变
>
> 存放于 Fiber 对象的 UpdateQueue 中：UpdateQueue 单项链表的结构
>
> 多个 Update 可以同时存在：例如一个事件里面存在三个 setState，创建三个 update 放到 UpdateQueue 中

```javascript
// 创建或更新updatequeue
export function enqueueUpdate<State>(fiber: Fiber, update: Update<State>) {
  // Update queues are created lazily.
  const alternate = fiber.alternate;
  let queue1;
  let queue2;
  if (alternate === null) {
    // There's only one fiber.
    queue1 = fiber.updateQueue;
    queue2 = null;
    if (queue1 === null) {
      queue1 = fiber.updateQueue = createUpdateQueue(fiber.memoizedState);
    }
  } else {
    // There are two owners.
    queue1 = fiber.updateQueue;
    queue2 = alternate.updateQueue;
    if (queue1 === null) {
      if (queue2 === null) {
        // Neither fiber has an update queue. Create new ones.
        queue1 = fiber.updateQueue = createUpdateQueue(fiber.memoizedState);
        queue2 = alternate.updateQueue = createUpdateQueue(
          alternate.memoizedState
        );
      } else {
        // Only one fiber has an update queue. Clone to create a new one.
        queue1 = fiber.updateQueue = cloneUpdateQueue(queue2);
      }
    } else {
      if (queue2 === null) {
        // Only one fiber has an update queue. Clone to create a new one.
        queue2 = alternate.updateQueue = cloneUpdateQueue(queue1);
      } else {
        // Both owners have an update queue.
      }
    }
  }
  if (queue2 === null || queue1 === queue2) {
    // There's only a single queue.
    appendUpdateToQueue(queue1, update);
  } else {
    // There are two queues. We need to append the update to both queues,
    // while accounting for the persistent structure of the list — we don't
    // want the same update to be added multiple times.
    if (queue1.lastUpdate === null || queue2.lastUpdate === null) {
      // One of the queues is not empty. We must add the update to both queues.
      appendUpdateToQueue(queue1, update);
      appendUpdateToQueue(queue2, update);
    } else {
      // Both queues are non-empty. The last update is the same in both lists,
      // because of structural sharing. So, only append to one of the lists.
      appendUpdateToQueue(queue1, update);
      // But we still need to update the `lastUpdate` pointer of queue2.
      queue2.lastUpdate = update;
    }
  }

  if (__DEV__) {
    if (
      fiber.tag === ClassComponent &&
      (currentlyProcessingQueue === queue1 ||
        (queue2 !== null && currentlyProcessingQueue === queue2)) &&
      !didWarnUpdateInsideUpdate
    ) {
      warningWithoutStack(
        false,
        "An update (setState, replaceState, or forceUpdate) was scheduled " +
          "from inside an update function. Update functions should be pure, " +
          "with zero side-effects. Consider using componentDidUpdate or a " +
          "callback."
      );
      didWarnUpdateInsideUpdate = true;
    }
  }
}
```

### expirationTime

详解见：https://react.jokcy.me/book/update/expiration-time.html

```javascript
// ReactFiberReconciler.js中
export function updateContainer(
  element: ReactNodeList,
  container: OpaqueRoot,
  parentComponent: ?React$Component<any, any>,
  callback: ?Function
): ExpirationTime {
  const current = container.current; // Fiber对象
  //!important
  const currentTime = requestCurrentTime();
  const expirationTime = computeExpirationForFiber(currentTime, current);

  return updateContainerAtExpirationTime(
    element,
    container,
    parentComponent,
    expirationTime,
    callback
  );
}
```

### requestCurrentTime

```javascript
// 目前粗略的理解目前为止到js加载完成的时间差
function requestCurrentTime() {
  //  已经进入到渲染阶段了
  if (isRendering) {
    // We're already rendering. Return the most recently read time.
    return currentSchedulerTime;
  }
  // Check if there's pending work.
  findHighestPriorityRoot(); // 从调度队列找到权限最高的root
  if (
    nextFlushedExpirationTime === NoWork ||
    nextFlushedExpirationTime === Never
  ) {
    // If there's no pending work, or if the pending work is offscreen, we can
    // read the current time without risk of tearing.
    recomputeCurrentRendererTime(); // 如下
    currentSchedulerTime = currentRendererTime;
    return currentSchedulerTime;
  }
  // There's already pending work. We might be in the middle of a browser
  // event. If we were to read the current time, it could cause multiple updates
  // within the same event to receive different expiration times, leading to
  // tearing. Return the last read time. During the next idle callback, the
  // time will be updated.
  return currentSchedulerTime;
}
```

### recomputeCurrentRendererTime

```javascript
function recomputeCurrentRendererTime() {
  // 从js加载完成到现在为止的时间间隔
  const currentTimeMs = now() - originalStartTimeMs; // originalStartTimeMs： 初始的now（）
  currentRendererTime = msToExpirationTime(currentTimeMs);
}
```

### msToExpirationTime

```javascript
const UNIT_SIZE = 10;
export function msToExpirationTime(ms: number): ExpirationTime {
  // Always add an offset so that we don't clash with the magic number for NoWork.
  return ((ms / UNIT_SIZE) | 0) + MAGIC_NUMBER_OFFSET;
}
```

## computeExpirationForFiber

```javascript
function computeExpirationForFiber(currentTime: ExpirationTime, fiber: Fiber) {
  let expirationTime;
  if (expirationContext !== NoWork) {
    // An explicit expiration context was set;
    expirationTime = expirationContext;
  } else if (isWorking) {
    if (isCommitting) {
      // Updates that occur during the commit phase should have sync priority
      // by default.
      expirationTime = Sync;
    } else {
      // Updates during the render phase should expire at the same time as
      // the work that is being rendered.
      expirationTime = nextRenderExpirationTime;
    }
  } else {
    // No explicit expiration context was set, and we're not currently
    // performing work. Calculate a new expiration time.
    if (fiber.mode & ConcurrentMode) {
      if (isBatchingInteractiveUpdates) {
        // This is an interactive update
        expirationTime = computeInteractiveExpiration(currentTime); // 如下
      } else {
        // This is an async update
        expirationTime = computeAsyncExpiration(currentTime); // 如下
      }
      // If we're in the middle of rendering a tree, do not update at the same
      // expiration time that is already rendering.
      if (nextRoot !== null && expirationTime === nextRenderExpirationTime) {
        expirationTime += 1;
      }
    } else {
      // This is a sync update
      expirationTime = Sync;
    }
  }
  if (isBatchingInteractiveUpdates) {
    // This is an interactive update. Keep track of the lowest pending
    // interactive expiration time. This allows us to synchronously flush
    // all interactive updates when needed.
    if (expirationTime > lowestPriorityPendingInteractiveExpirationTime) {
      lowestPriorityPendingInteractiveExpirationTime = expirationTime;
    }
  }
  return expirationTime;
}
```

## computeInteractiveExpiration

```javascript
export const HIGH_PRIORITY_EXPIRATION = __DEV__ ? 500 : 150;
export const HIGH_PRIORITY_BATCH_SIZE = 100;

export function computeInteractiveExpiration(currentTime: ExpirationTime) {
  return computeExpirationBucket(
    currentTime,
    HIGH_PRIORITY_EXPIRATION,
    HIGH_PRIORITY_BATCH_SIZE
  );
}
```

## computeAsyncExpiration

```javascript
export const LOW_PRIORITY_EXPIRATION = 5000;
export const LOW_PRIORITY_BATCH_SIZE = 250;

export function computeAsyncExpiration(
  currentTime: ExpirationTime
): ExpirationTime {
  return computeExpirationBucket(
    currentTime,
    LOW_PRIORITY_EXPIRATION,
    LOW_PRIORITY_BATCH_SIZE
  );
}
```

## computeExpirationBucket

```javascript
function computeExpirationBucket(
  currentTime,
  expirationInMs,
  bucketSizeMs
): ExpirationTime {
  return (
    MAGIC_NUMBER_OFFSET +
    ceiling(
      currentTime - MAGIC_NUMBER_OFFSET + expirationInMs / UNIT_SIZE,
      bucketSizeMs / UNIT_SIZE
    )
  );
}
```

计算为了将固定时间间断的，多次 setState 数据的更新当成一次更新，在这个时间间断内优先级是一样的
