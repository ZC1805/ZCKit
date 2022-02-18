//
//  ZCQueueHandler.m
//  ZCKit
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCQueueHandler.h"

@implementation ZCQueueHandler

#pragma mark - Dispatch
void main_imp(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

void main_delay(NSTimeInterval delay, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

void main_delayPop(dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

#pragma mark - Serial
static const void * const serialSyncQueueKey = &serialSyncQueueKey;
dispatch_queue_t dispatchSerialSyncQueue(void) {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("serial_queue_sync", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(queue, serialSyncQueueKey, (void *)serialSyncQueueKey, NULL);
    });
    return queue;
}

void sync_serial(dispatch_block_t block) {
    if (dispatch_get_specific(serialSyncQueueKey)) {
        block();
    } else {
        dispatch_sync(dispatchSerialSyncQueue(), block);
    }
}

static const void * const serialAsyncQueueKey = &serialAsyncQueueKey;
dispatch_queue_t dispatchSerialAsyncQueue(void) {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("serial_queue_async", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(queue, serialAsyncQueueKey, (void *)serialAsyncQueueKey, NULL);
    });
    return queue;
}

void async_serial(dispatch_block_t block) {
    if (dispatch_get_specific(serialAsyncQueueKey)) {
        block();
    } else {
        dispatch_async(dispatchSerialAsyncQueue(), block);
    }
}

#pragma mark - Concurrent
static const void * const concurrentAsyncQueueKey = &concurrentAsyncQueueKey;
dispatch_queue_t dispatchConcurrentAsyncQueue(void) {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("concurrent_queue_async", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_set_specific(queue, concurrentAsyncQueueKey, (void *)concurrentAsyncQueueKey, NULL);
    });
    return queue;
}

void async_concurrent(dispatch_block_t block) {
    if (dispatch_get_specific(concurrentAsyncQueueKey)) {
        block();
    } else {
        dispatch_async(dispatchConcurrentAsyncQueue(), block);
    }
}

#pragma mark - Apply
void apply_concurrent(int count, void(^operate)(int index)) {
    dispatch_queue_t queue = dispatch_queue_create("apply_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_apply(count, queue, ^(size_t i) {
        if (operate) { operate((int)i); }
    });
}

#pragma mark - Group
void group_concurrent(int operateCount, bool waitCompletion,
                      void(^operate)(int index, void(^operateCompletion)(BOOL isSuccess)),
                      void(^ _Nullable groupCompletion)(NSArray <NSNumber *>*failIndexs)) {
    dispatch_queue_t queue = dispatch_queue_create("group_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    NSMutableArray *fails = [NSMutableArray array];
    for (int i = 0; i < operateCount; i ++) {
        dispatch_group_enter(group);
        dispatch_group_async(group, queue, ^{
            if (operate) { operate(i, ^(BOOL isSuccess){
                if (!isSuccess) { [fails addObject:@(i)]; };
                dispatch_group_leave(group); });
            } else {
                dispatch_group_leave(group);
            }
        });
    }
    if (waitCompletion) {
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        if (groupCompletion) { groupCompletion(fails.copy); }
    });
}

#pragma mark - Barrier
void barrier_concurrent(int beforeOperateCount, void(^beforeOperateImp)(int index),
                        void(^barrierOperateImp)(void),
                        int afterOperateCount, void(^afterOperateImp)(int index)) {
    dispatch_queue_t queue = dispatch_queue_create("barrier_concurrent_queue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0; i < beforeOperateCount; i ++) {
        if (beforeOperateImp) {
            dispatch_async(queue, ^{
                beforeOperateImp(i);
            });
        }
    }
    if (barrierOperateImp) {
        dispatch_barrier_async(queue, ^{
            barrierOperateImp();
        });
    }
    for (int i = 0; i < afterOperateCount; i ++) {
        if (afterOperateImp) {
            dispatch_async(queue, ^{
                afterOperateImp(i);
            });
        }
    }
}

@end
