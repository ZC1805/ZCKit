//
//  ZCQueueHandle.h
//  ZCKit
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCQueueHandle : NSObject

#pragma mark - serial
void main_imp(dispatch_block_t block);  /**< GCD主线程执行 */

void serial_safe(dispatch_block_t block);  /**< GCD串行安全，同步执行，同下 */

void serial_sync(dispatch_block_t block);  /**< GCD串行同步，犹如主线程，同上 */

void serial_async(dispatch_block_t block);  /**< GCD串行异步，不阻塞外部线程，block内部若是同线程将按顺序执行 */

void concurrent_async(dispatch_block_t block);  /**< GCD并行异步，不阻塞外部线程，和外部同线程可并发，block内部若是同线程将按顺序执行 */

#pragma mark - apply
void apply_serial_queue(void(^operation)(dispatch_queue_t queue));  /**< GCD串行迭代队列 */

void apply_concurrent_queue(void(^operation)(dispatch_queue_t queue));  /**< GCD并行迭代队列，速度快 */

#pragma mark - group
//GCD组串行队列执行，operations回调可在里面加入具体执行dispatch_group_async(group, queue, operation)
void group_serial(void(^operations)(dispatch_group_t group, dispatch_queue_t queue), bool wait, void(^complete)(void));

//GCD组并行队列执行，operations回调可在里面加入具体执行dispatch_group_async(group, queue, operation)
void group_concurrent(void(^operations)(dispatch_group_t group, dispatch_queue_t queue), bool wait, void(^complete)(void));

@end

NS_ASSUME_NONNULL_END
