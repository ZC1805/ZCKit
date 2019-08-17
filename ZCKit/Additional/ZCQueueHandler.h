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

#pragma mark - dispatch
/** GCD主线程执行 */
void main_imp(dispatch_block_t block);

/** GCD主线程延迟1.5秒执行 */
void main_delayPop(dispatch_block_t block);

/** GCD主线程延迟执行 */
void main_delay(NSTimeInterval delayTime, dispatch_block_t block);

/** GCD串行同步，会阻塞外部线程并且不会开启新的线程，串行执行内部任务 */
void sync_serial(dispatch_block_t block);

/** GCD串行异步，不阻塞外部线程并且可能开启1条新线程串行执行内部任务，block内同线程将按顺序执行 */
void async_serial(dispatch_block_t block);

/** GCD并发异步，不阻塞外部线程并且可能开启多条新线程并行执行内部任务，block(非主线程)内同线程将按顺序执行 */
void async_concurrent(dispatch_block_t block);

#pragma mark - apply
/** GCD多线程迭代(会阻塞当前线程)，operate执行在子线程或者主线程中，count为循环次数，operate为每次任务 */
void apply_concurrent(int count, void(^operate)(int index));

#pragma mark - group
/** GCD异步并发多任务，operateCount为operate执行的次数，waitCompletion为是否阻塞当前线程，groupCompletion所有操作执行完成的回调(主线程) */
/** operate执行在非主线程，operate会执行operateCount次(index从0开始)，operate每次执行完时可调用operateCompletion()来告知任务完成时刻 */
void group_concurrent(int operateCount, bool waitCompletion,
                      void(^operate)(int index, void(^operateCompletion)(void)),
                      void(^ _Nullable groupCompletion)(void));

@end

NS_ASSUME_NONNULL_END
