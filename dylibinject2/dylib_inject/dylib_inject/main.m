//
//  main.m
//  dylib_inject
//
//  Created by haidragon on 2019/4/19.
//  Copyright © 2019 haidragon. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "indy.h"
#include <dlfcn.h>
// In your injector process:
typedef
uint32_t (*foo_entry)(void *user_data);
void test(){
    void *handle = dlopen("libtestdylib.dylib", 1);
    if (handle != NULL) {
        foo_entry entry = dlsym(handle, "foo_entry");
        printf("%p\n",entry);
        
    }
}
int main(int argc, char **argv)
{
    //test();
    const char *str = "Hello world!";
    
    struct indy_result res;
    indy_inject(&(struct indy_info) {
        .pid = 698,
        .dylib_path = "libtestdylib.dylib",
        .dylib_entry_symbol = "DylibMain1",
        .user_data = (const void *) str,
        .user_data_size = strlen(str) + 1
    }, &res);
    if (res.error != NULL) {
        fprintf(stderr, res.error, res.os_value);
        return EXIT_FAILURE;
    }
    
    return res.exit_status;
}


