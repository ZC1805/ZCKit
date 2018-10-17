//
//  ZCQueueHandle.m
//  ZCKit
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import "ZCQueueHandle.h"

@implementation ZCQueueHandle

#pragma mark - GCD store
void main_imp(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static const void *const serialStoreQueueKey = &serialStoreQueueKey;
dispatch_queue_t dispatchStoreSerialQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("serial_queue_store", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(queue, serialStoreQueueKey, (void *)serialStoreQueueKey, NULL);
    });
    return queue;
}

void serial_safe(dispatch_block_t block) {
    if (dispatch_get_specific(serialStoreQueueKey)) {
        block();
    } else {
        dispatch_sync(dispatchStoreSerialQueue(), block);
    }
}

#pragma mark - GCD serial
static const void *const serialSyncQueueKey = &serialSyncQueueKey;
dispatch_queue_t dispatchSerialSyncQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("serial_queue_sync", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(queue, serialSyncQueueKey, (void *)serialSyncQueueKey, NULL);
    });
    return queue;
}

void serial_sync(dispatch_block_t block) {
    if (dispatch_get_specific(serialSyncQueueKey)) {
        block();
    } else {
        dispatch_sync(dispatchSerialSyncQueue(), block);
    }
}

static const void *const serialAsyncQueueKey = &serialAsyncQueueKey;
dispatch_queue_t dispatchSerialAsyncQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("serial_queue_async", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(queue, serialAsyncQueueKey, (void *)serialAsyncQueueKey, NULL);
    });
    return queue;
}

void serial_async(dispatch_block_t block) {
    if (dispatch_get_specific(serialAsyncQueueKey)) {
        block();
    } else {
        dispatch_async(dispatchSerialAsyncQueue(), block);
    }
}

#pragma mark - GCD concurrent
static const void *const concurrentAsyncQueueKey = &concurrentAsyncQueueKey;
dispatch_queue_t dispatchConcurrentAsyncQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("concurrent_queue_async", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_set_specific(queue, concurrentAsyncQueueKey, (void *)concurrentAsyncQueueKey, NULL);
    });
    return queue;
}

void concurrent_async(dispatch_block_t block) {
    if (dispatch_get_specific(concurrentAsyncQueueKey)) {
        block();
    } else {
        dispatch_async(dispatchConcurrentAsyncQueue(), block);
    }
}

#pragma mark - GCD apply
void apply_serial_queue(void(^operation)(dispatch_queue_t queue)) {  //串行迭代队列
    dispatch_queue_t serialQueue = dispatch_queue_create("serial_queue_apply", DISPATCH_QUEUE_SERIAL);
    if (operation) {
        operation(serialQueue);
    }
}

void apply_concurrent_queue(void(^operation)(dispatch_queue_t queue)) {  //并行迭代队列，所以使用dispatch_apply可以运行的更快
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrent_queue_apply", DISPATCH_QUEUE_CONCURRENT);
    if (operation) {
        operation(concurrentQueue);
    }
}

#pragma mark - GCD group
dispatch_queue_t createSerialQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("my_serial_one_queue", DISPATCH_QUEUE_SERIAL);
    });
    return queue;
}

dispatch_queue_t createConcurrentQueue() {
    static dispatch_queue_t queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("my_concurrent_one_queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return queue;
}

void group_serial(void(^operations)(dispatch_group_t group, dispatch_queue_t queue), bool wait, void(^complete)(void)) {
    dispatch_queue_t my_sarial_queue = createSerialQueue();
    dispatch_group_t my_queue_group = dispatch_group_create();
    operations(my_queue_group, my_sarial_queue);
    dispatch_group_notify(my_queue_group, my_sarial_queue, complete);
    if (wait) dispatch_group_wait(my_queue_group, DISPATCH_TIME_FOREVER);
}

void group_concurrent(void(^operations)(dispatch_group_t group, dispatch_queue_t queue), bool wait, void(^complete)(void)) {
    dispatch_queue_t my_concurrent_queue = createConcurrentQueue();
    dispatch_group_t my_queue_group = dispatch_group_create();
    operations(my_queue_group, my_concurrent_queue);
    dispatch_group_notify(my_queue_group, my_concurrent_queue, complete);
    if (wait) dispatch_group_wait(my_queue_group, DISPATCH_TIME_FOREVER);
}

@end
