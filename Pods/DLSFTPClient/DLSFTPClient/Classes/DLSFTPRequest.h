//
//  DLSFTPRequest.h
//  DLSFTPClient
//
//  Created by Dan Leehr on 3/4/13.
//  Copyright (c) 2013 Dan Leehr. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//
//  Redistributions of source code must retain the above copyright notice,
//  this list of conditions and the following disclaimer.
//
//  Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
// IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
// HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
// TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import <Foundation/Foundation.h>

#import "DLSFTP.h"

typedef void(^DLSFTPRequestCancelHandler)(void);

@class DLSFTPConnection;

@interface DLSFTPRequest : NSObject

@property (nonatomic, readonly, getter = isCancelled) BOOL cancelled;
@property (nonatomic, weak) DLSFTPConnection *connection;
@property (nonatomic, readwrite, copy) DLSFTPRequestCancelHandler cancelHandler;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, copy) id successBlock;
@property (nonatomic, copy) DLSFTPClientFailureBlock failureBlock;

// may be called by the connection or the end user
- (void)cancel;

// Only the connection should call these methods
- (void)start; // subclasses must override
- (void)succeed; // subclasses must override and invoke their success blocks
- (void)fail; // subclasses need not override this

// Only subclasses should call these methods
- (BOOL)ready;
- (BOOL)pathIsValid:(NSString *)path;
- (BOOL)checkSftp;
- (NSError *)errorWithCode:(eSFTPClientErrorCode)errorCode
          errorDescription:(NSString *)errorDescription
           underlyingError:(NSNumber *)underlyingError;
@end
