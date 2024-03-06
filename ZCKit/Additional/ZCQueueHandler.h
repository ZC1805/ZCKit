//
//  ZCQueueHandler.h
//  ZCKit
//
//  Created by admin on 2018/10/17.
//  Copyright © 2018 Squat in house. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZCQueueHandler : NSObject  /**< 线程处理类 */

/**< dispatch_sync往一个派发队列上提交一个同步执行的Block任务，阻塞当前的外部线程且不开新线程。 */
/**< dispatch_async往一个派发队列上提交一个异步执行的Block任务，不阻塞当前的外部线程且可能会开新线程。 */

/**< GCD主线程执行 */
void main_imp(dispatch_block_t block);

/**< GCD主线程延迟1.5秒执行 */
void main_delayPop(dispatch_block_t block);

/**< GCD主线程延迟执行 */
void main_delay(NSTimeInterval delayTime, dispatch_block_t block);

/**< GCD串行同步，会阻塞外部线程并且不会开启新的线程，串行执行内部任务 */
void sync_serial(dispatch_block_t block);

/**< GCD串行异步，不阻塞外部线程并且可能开启1条新线程串行执行内部任务，block内同线程将按顺序执行 */
void async_serial(dispatch_block_t block);

/**< GCD并发异步，不阻塞外部线程并且可能开启多条新线程并行执行内部任务，block(非主线程)内同线程将按顺序执行 */
void async_concurrent(dispatch_block_t block);

#pragma mark - Apply
/**< GCD多线程迭代(会阻塞当前线程)，operate执行在子线程或者主线程中，count为循环次数，operate为每次任务 */
void apply_concurrent(int count, void(^operate)(int index));

#pragma mark - Group
/**< GCD异步并发多任务，operateCount为operate执行的次数，waitCompletion为是否阻塞当前线程，groupCompletion所有操作执行完成的回调(主线程) */
/**< operate执行在非主线程异步执行，operate多次调用，operate会执行operateCount次(index从0开始)，operate每次执行完时可调用operateCompletion()来告知任务完成时刻 */
/**< isSuccess表示每个任务的结果是成功还是失败，failIndexs表示按给定index的任务那些返回的处理结果是失败 */
void group_concurrent(int operateCount, bool waitCompletion,
                      void(^ _Nullable operate)(int index, void(^operateCompletion)(BOOL isSuccess)),
                      void(^ _Nullable groupCompletion)(NSArray <NSNumber *>*failIndexs));

#pragma mark - Barrier
/**< 解决多任务并发执行然后等全结束再又并发多任务的情况，类似承前启后的情形，所有执行都在非主线程异步执行 */
/**< 前边beforeOperateCount准备并发任务个数，beforeOperateImp前边每个任务的具体执行 */
/**< 承前启后barrierOperateImp并发的一个任务的实现 */
/**< 后边afterOperateCount准备并发任务个数，afterOperateImp后边每个任务的具体执行 */
void barrier_concurrent(int beforeOperateCount, void(^ _Nullable beforeOperateImp)(int index),
                        void(^_Nullable barrierOperateImp)(void),
                        int afterOperateCount, void(^ _Nullable afterOperateImp)(int index));

@end

NS_ASSUME_NONNULL_END
