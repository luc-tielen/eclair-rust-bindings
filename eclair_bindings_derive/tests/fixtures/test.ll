declare external ccc i8* @malloc(i32)

declare external ccc void @free(i8*)

declare external ccc void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

declare external ccc void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1)

declare external ccc i32 @memcmp(i8*, i8*, i64)

%node_data_t_0 = type {%node_t_0*, i16, i16, i1}

%node_t_0 = type {%node_data_t_0, [30 x [2 x i32]]}

%inner_node_t_0 = type {%node_t_0, [31 x %node_t_0*]}

%btree_iterator_t_0 = type {%node_t_0*, i16}

%btree_t_0 = type {%node_t_0*, %node_t_0*}

define external ccc i8 @btree_value_compare_0(i32 %lhs_0, i32 %rhs_0) {
start:
  %0 = icmp ult i32 %lhs_0, %rhs_0
  br i1 %0, label %if_0, label %end_if_0
if_0:
  ret i8 -1
end_if_0:
  %1 = icmp ugt i32 %lhs_0, %rhs_0
  %2 = select i1 %1, i8 1, i8 0
  ret i8 %2
}

define external ccc i8 @btree_value_compare_values_0([2 x i32]* %lhs_0, [2 x i32]* %rhs_0) {
start:
  br label %comparison_0
comparison_0:
  %0 = getelementptr [2 x i32], [2 x i32]* %lhs_0, i32 0, i32 0
  %1 = getelementptr [2 x i32], [2 x i32]* %rhs_0, i32 0, i32 0
  %2 = load i32, i32* %0
  %3 = load i32, i32* %1
  %4 = call ccc i8 @btree_value_compare_0(i32 %2, i32 %3)
  %5 = icmp eq i8 %4, 0
  br i1 %5, label %comparison_1, label %end_0
comparison_1:
  %6 = getelementptr [2 x i32], [2 x i32]* %lhs_0, i32 0, i32 1
  %7 = getelementptr [2 x i32], [2 x i32]* %rhs_0, i32 0, i32 1
  %8 = load i32, i32* %6
  %9 = load i32, i32* %7
  %10 = call ccc i8 @btree_value_compare_0(i32 %8, i32 %9)
  br label %end_0
end_0:
  %11 = phi i8 [%10, %comparison_1], [%4, %comparison_0]
  ret i8 %11
}

define external ccc %node_t_0* @btree_node_new_0(i1 %type_0) {
start:
  %0 = select i1 %type_0, i32 256, i32 504
  %1 = call ccc i8* @malloc(i32 %0)
  %2 = bitcast i8* %1 to %node_t_0*
  %3 = getelementptr %node_t_0, %node_t_0* %2, i32 0, i32 0, i32 0
  store %node_t_0* zeroinitializer, %node_t_0** %3
  %4 = getelementptr %node_t_0, %node_t_0* %2, i32 0, i32 0, i32 1
  store i16 0, i16* %4
  %5 = getelementptr %node_t_0, %node_t_0* %2, i32 0, i32 0, i32 2
  store i16 0, i16* %5
  %6 = getelementptr %node_t_0, %node_t_0* %2, i32 0, i32 0, i32 3
  store i1 %type_0, i1* %6
  %7 = getelementptr %node_t_0, %node_t_0* %2, i32 0, i32 1
  %8 = bitcast [30 x [2 x i32]]* %7 to i8*
  call ccc void @llvm.memset.p0i8.i64(i8* %8, i8 0, i64 240, i1 0)
  %9 = icmp eq i1 %type_0, 1
  br i1 %9, label %if_0, label %end_if_0
if_0:
  %10 = bitcast %node_t_0* %2 to %inner_node_t_0*
  %11 = getelementptr %inner_node_t_0, %inner_node_t_0* %10, i32 0, i32 1
  %12 = bitcast [31 x %node_t_0*]* %11 to i8*
  call ccc void @llvm.memset.p0i8.i64(i8* %12, i8 0, i64 248, i1 0)
  br label %end_if_0
end_if_0:
  ret %node_t_0* %2
}

define external ccc void @btree_node_delete_0(%node_t_0* %node_0) {
start:
  %0 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 3
  %1 = load i1, i1* %0
  %2 = icmp eq i1 %1, 1
  br i1 %2, label %if_0, label %end_if_1
if_0:
  %3 = bitcast %node_t_0* %node_0 to %inner_node_t_0*
  %4 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 2
  %5 = load i16, i16* %4
  br label %for_begin_0
for_begin_0:
  %6 = phi i16 [0, %if_0], [%11, %end_if_0]
  %7 = icmp ule i16 %6, %5
  br i1 %7, label %for_body_0, label %for_end_0
for_body_0:
  %8 = getelementptr %inner_node_t_0, %inner_node_t_0* %3, i32 0, i32 1, i16 %6
  %9 = load %node_t_0*, %node_t_0** %8
  %10 = icmp ne %node_t_0* %9, zeroinitializer
  br i1 %10, label %if_1, label %end_if_0
if_1:
  call ccc void @btree_node_delete_0(%node_t_0* %9)
  br label %end_if_0
end_if_0:
  %11 = add i16 1, %6
  br label %for_begin_0
for_end_0:
  br label %end_if_1
end_if_1:
  %12 = bitcast %node_t_0* %node_0 to i8*
  call ccc void @free(i8* %12)
  ret void
}

define external ccc i64 @node_count_entries_0(%node_t_0* %node_0) {
start:
  %0 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 2
  %1 = load i16, i16* %0
  %2 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 3
  %3 = load i1, i1* %2
  %4 = icmp eq i1 %3, 0
  %5 = zext i16 %1 to i64
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i64 %5
end_if_0:
  %6 = bitcast %node_t_0* %node_0 to %inner_node_t_0*
  %7 = alloca i64
  store i64 %5, i64* %7
  %8 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 2
  %9 = load i16, i16* %8
  br label %for_begin_0
for_begin_0:
  %10 = phi i16 [0, %end_if_0], [%17, %for_body_0]
  %11 = icmp ule i16 %10, %9
  br i1 %11, label %for_body_0, label %for_end_0
for_body_0:
  %12 = load i64, i64* %7
  %13 = getelementptr %inner_node_t_0, %inner_node_t_0* %6, i32 0, i32 1, i16 %10
  %14 = load %node_t_0*, %node_t_0** %13
  %15 = call ccc i64 @node_count_entries_0(%node_t_0* %14)
  %16 = add i64 %12, %15
  store i64 %16, i64* %7
  %17 = add i16 1, %10
  br label %for_begin_0
for_end_0:
  %18 = load i64, i64* %7
  ret i64 %18
}

define external ccc i16 @btree_node_split_point_0() {
start:
  %0 = mul i16 3, 30
  %1 = udiv i16 %0, 4
  %2 = sub i16 30, 2
  %3 = icmp ult i16 %1, %2
  %4 = select i1 %3, i16 %1, i16 %2
  ret i16 %4
}

define external ccc void @btree_node_split_0(%node_t_0* %node_0, %node_t_0** %root_0) {
start:
  %0 = call ccc i16 @btree_node_split_point_0()
  %1 = add i16 1, %0
  %2 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 3
  %3 = load i1, i1* %2
  %4 = call ccc %node_t_0* @btree_node_new_0(i1 %3)
  %5 = alloca i16
  store i16 0, i16* %5
  br label %for_begin_0
for_begin_0:
  %6 = phi i16 [%1, %start], [%13, %for_body_0]
  %7 = icmp ult i16 %6, 30
  br i1 %7, label %for_body_0, label %for_end_0
for_body_0:
  %8 = load i16, i16* %5
  %9 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 1, i16 %6
  %10 = load [2 x i32], [2 x i32]* %9
  %11 = getelementptr %node_t_0, %node_t_0* %4, i32 0, i32 1, i16 %8
  store [2 x i32] %10, [2 x i32]* %11
  %12 = add i16 1, %8
  store i16 %12, i16* %5
  %13 = add i16 1, %6
  br label %for_begin_0
for_end_0:
  %14 = icmp eq i1 %3, 1
  br i1 %14, label %if_0, label %end_if_0
if_0:
  %15 = bitcast %node_t_0* %4 to %inner_node_t_0*
  %16 = bitcast %node_t_0* %node_0 to %inner_node_t_0*
  store i16 0, i16* %5
  br label %for_begin_1
for_begin_1:
  %17 = phi i16 [%1, %if_0], [%26, %for_body_1]
  %18 = icmp ult i16 %17, 30
  br i1 %18, label %for_body_1, label %for_end_1
for_body_1:
  %19 = load i16, i16* %5
  %20 = getelementptr %inner_node_t_0, %inner_node_t_0* %16, i32 0, i32 1, i16 %17
  %21 = load %node_t_0*, %node_t_0** %20
  %22 = getelementptr %node_t_0, %node_t_0* %21, i32 0, i32 0, i32 0
  store %node_t_0* %4, %node_t_0** %22
  %23 = getelementptr %node_t_0, %node_t_0* %21, i32 0, i32 0, i32 2
  store i16 %19, i16* %23
  %24 = getelementptr %inner_node_t_0, %inner_node_t_0* %15, i32 0, i32 1, i16 %19
  store %node_t_0* %21, %node_t_0** %24
  %25 = add i16 1, %19
  store i16 %25, i16* %5
  %26 = add i16 1, %17
  br label %for_begin_1
for_end_1:
  br label %end_if_0
end_if_0:
  %27 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 2
  store i16 %0, i16* %27
  %28 = sub i16 30, %0
  %29 = sub i16 %28, 1
  %30 = getelementptr %node_t_0, %node_t_0* %4, i32 0, i32 0, i32 2
  store i16 %29, i16* %30
  call ccc void @btree_node_grow_parent_0(%node_t_0* %node_0, %node_t_0** %root_0, %node_t_0* %4)
  ret void
}

define external ccc void @btree_node_grow_parent_0(%node_t_0* %node_0, %node_t_0** %root_0, %node_t_0* %sibling_0) {
start:
  %0 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 0
  %1 = load %node_t_0*, %node_t_0** %0
  %2 = icmp eq %node_t_0* %1, zeroinitializer
  %3 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 2
  %4 = load i16, i16* %3
  br i1 %2, label %create_new_root_0, label %insert_new_node_in_parent_0
create_new_root_0:
  %5 = call ccc %node_t_0* @btree_node_new_0(i1 1)
  %6 = bitcast %node_t_0* %5 to %inner_node_t_0*
  %7 = getelementptr %node_t_0, %node_t_0* %5, i32 0, i32 0, i32 2
  store i16 1, i16* %7
  %8 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 1, i16 %4
  %9 = load [2 x i32], [2 x i32]* %8
  %10 = getelementptr %node_t_0, %node_t_0* %5, i32 0, i32 1, i16 0
  store [2 x i32] %9, [2 x i32]* %10
  %11 = getelementptr %inner_node_t_0, %inner_node_t_0* %6, i32 0, i32 1, i16 0
  store %node_t_0* %node_0, %node_t_0** %11
  %12 = getelementptr %inner_node_t_0, %inner_node_t_0* %6, i32 0, i32 1, i16 1
  store %node_t_0* %sibling_0, %node_t_0** %12
  %13 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 0
  store %node_t_0* %5, %node_t_0** %13
  %14 = getelementptr %node_t_0, %node_t_0* %sibling_0, i32 0, i32 0, i32 0
  store %node_t_0* %5, %node_t_0** %14
  %15 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 1
  store i16 0, i16* %15
  %16 = getelementptr %node_t_0, %node_t_0* %sibling_0, i32 0, i32 0, i32 1
  store i16 1, i16* %16
  store %node_t_0* %5, %node_t_0** %root_0
  ret void
insert_new_node_in_parent_0:
  %17 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 1
  %18 = load i16, i16* %17
  %19 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 1, i16 %4
  call ccc void @btree_node_insert_inner_0(%node_t_0* %1, %node_t_0** %root_0, i16 %18, %node_t_0* %node_0, [2 x i32]* %19, %node_t_0* %sibling_0)
  ret void
}

define external ccc void @btree_node_insert_inner_0(%node_t_0* %node_0, %node_t_0** %root_0, i16 %pos_0, %node_t_0* %predecessor_0, [2 x i32]* %key_0, %node_t_0* %new_node_0) {
start:
  %0 = alloca i16
  store i16 %pos_0, i16* %0
  %1 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 2
  %2 = load i16, i16* %1
  %3 = icmp uge i16 %2, 30
  br i1 %3, label %if_0, label %end_if_1
if_0:
  %4 = load i16, i16* %0
  %5 = call ccc i16 @btree_node_rebalance_or_split_0(%node_t_0* %node_0, %node_t_0** %root_0, i16 %pos_0)
  %6 = sub i16 %4, %5
  store i16 %6, i16* %0
  %7 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 2
  %8 = load i16, i16* %7
  %9 = icmp ugt i16 %6, %8
  br i1 %9, label %if_1, label %end_if_0
if_1:
  %10 = sub i16 %6, %8
  %11 = sub i16 %10, 1
  store i16 %11, i16* %0
  %12 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 0
  %13 = load %node_t_0*, %node_t_0** %12
  %14 = bitcast %node_t_0* %13 to %inner_node_t_0*
  %15 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 1
  %16 = load i16, i16* %15
  %17 = add i16 1, %16
  %18 = getelementptr %inner_node_t_0, %inner_node_t_0* %14, i32 0, i32 1, i16 %17
  %19 = load %node_t_0*, %node_t_0** %18
  call ccc void @btree_node_insert_inner_0(%node_t_0* %19, %node_t_0** %root_0, i16 %11, %node_t_0* %predecessor_0, [2 x i32]* %key_0, %node_t_0* %new_node_0)
  ret void
end_if_0:
  br label %end_if_1
end_if_1:
  %20 = bitcast %node_t_0* %node_0 to %inner_node_t_0*
  %21 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 2
  %22 = load i16, i16* %21
  %23 = sub i16 %22, 1
  %24 = load i16, i16* %0
  br label %for_begin_0
for_begin_0:
  %25 = phi i16 [%23, %end_if_1], [%40, %for_body_0]
  %26 = icmp uge i16 %25, %24
  br i1 %26, label %for_body_0, label %for_end_0
for_body_0:
  %27 = add i16 %25, 1
  %28 = add i16 %25, 2
  %29 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 1, i16 %25
  %30 = load [2 x i32], [2 x i32]* %29
  %31 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 1, i16 %27
  store [2 x i32] %30, [2 x i32]* %31
  %32 = getelementptr %inner_node_t_0, %inner_node_t_0* %20, i32 0, i32 1, i16 %27
  %33 = load %node_t_0*, %node_t_0** %32
  %34 = getelementptr %inner_node_t_0, %inner_node_t_0* %20, i32 0, i32 1, i16 %28
  store %node_t_0* %33, %node_t_0** %34
  %35 = getelementptr %inner_node_t_0, %inner_node_t_0* %20, i32 0, i32 1, i16 %28
  %36 = load %node_t_0*, %node_t_0** %35
  %37 = getelementptr %node_t_0, %node_t_0* %36, i32 0, i32 0, i32 1
  %38 = load i16, i16* %37
  %39 = add i16 1, %38
  store i16 %39, i16* %37
  %40 = sub i16 %25, 1
  br label %for_begin_0
for_end_0:
  %41 = load [2 x i32], [2 x i32]* %key_0
  %42 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 1, i16 %24
  store [2 x i32] %41, [2 x i32]* %42
  %43 = add i16 %24, 1
  %44 = getelementptr %inner_node_t_0, %inner_node_t_0* %20, i32 0, i32 1, i16 %43
  store %node_t_0* %new_node_0, %node_t_0** %44
  %45 = getelementptr %node_t_0, %node_t_0* %new_node_0, i32 0, i32 0, i32 0
  store %node_t_0* %node_0, %node_t_0** %45
  %46 = getelementptr %node_t_0, %node_t_0* %new_node_0, i32 0, i32 0, i32 1
  store i16 %43, i16* %46
  %47 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 2
  %48 = load i16, i16* %47
  %49 = add i16 1, %48
  store i16 %49, i16* %47
  ret void
}

define external ccc i16 @btree_node_rebalance_or_split_0(%node_t_0* %node_0, %node_t_0** %root_0, i16 %idx_0) {
start:
  %0 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 0
  %1 = load %node_t_0*, %node_t_0** %0
  %2 = bitcast %node_t_0* %1 to %inner_node_t_0*
  %3 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 1
  %4 = load i16, i16* %3
  %5 = icmp ne %inner_node_t_0* %2, zeroinitializer
  %6 = icmp ugt i16 %4, 0
  %7 = and i1 %5, %6
  br i1 %7, label %rebalance_0, label %split_0
rebalance_0:
  %8 = sub i16 %4, 1
  %9 = getelementptr %inner_node_t_0, %inner_node_t_0* %2, i32 0, i32 1, i16 %8
  %10 = load %node_t_0*, %node_t_0** %9
  %11 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 2
  %12 = load i16, i16* %11
  %13 = sub i16 30, %12
  %14 = icmp slt i16 %13, %idx_0
  %15 = select i1 %14, i16 %13, i16 %idx_0
  %16 = icmp ugt i16 %15, 0
  br i1 %16, label %if_0, label %end_if_1
if_0:
  %17 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 1
  %18 = load i16, i16* %17
  %19 = sub i16 %18, 1
  %20 = getelementptr %inner_node_t_0, %inner_node_t_0* %2, i32 0, i32 0, i32 1, i16 %19
  %21 = load [2 x i32], [2 x i32]* %20
  %22 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 2
  %23 = load i16, i16* %22
  %24 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 1, i16 %23
  store [2 x i32] %21, [2 x i32]* %24
  %25 = sub i16 %15, 1
  br label %for_begin_0
for_begin_0:
  %26 = phi i16 [0, %if_0], [%33, %for_body_0]
  %27 = icmp ult i16 %26, %25
  br i1 %27, label %for_body_0, label %for_end_0
for_body_0:
  %28 = add i16 %23, 1
  %29 = add i16 %26, %28
  %30 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 1, i16 %26
  %31 = load [2 x i32], [2 x i32]* %30
  %32 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 1, i16 %29
  store [2 x i32] %31, [2 x i32]* %32
  %33 = add i16 1, %26
  br label %for_begin_0
for_end_0:
  %34 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 1, i16 %25
  %35 = load [2 x i32], [2 x i32]* %34
  store [2 x i32] %35, [2 x i32]* %20
  %36 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 2
  %37 = load i16, i16* %36
  %38 = sub i16 %37, %15
  br label %for_begin_1
for_begin_1:
  %39 = phi i16 [0, %for_end_0], [%45, %for_body_1]
  %40 = icmp ult i16 %39, %38
  br i1 %40, label %for_body_1, label %for_end_1
for_body_1:
  %41 = add i16 %39, %15
  %42 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 1, i16 %41
  %43 = load [2 x i32], [2 x i32]* %42
  %44 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 1, i16 %39
  store [2 x i32] %43, [2 x i32]* %44
  %45 = add i16 1, %39
  br label %for_begin_1
for_end_1:
  %46 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 3
  %47 = load i1, i1* %46
  %48 = icmp eq i1 %47, 1
  br i1 %48, label %if_1, label %end_if_0
if_1:
  %49 = bitcast %node_t_0* %node_0 to %inner_node_t_0*
  %50 = bitcast %node_t_0* %10 to %inner_node_t_0*
  br label %for_begin_2
for_begin_2:
  %51 = phi i16 [0, %if_1], [%64, %for_body_2]
  %52 = icmp ult i16 %51, %15
  br i1 %52, label %for_body_2, label %for_end_2
for_body_2:
  %53 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 2
  %54 = load i16, i16* %53
  %55 = add i16 %54, 1
  %56 = add i16 %51, %55
  %57 = getelementptr %inner_node_t_0, %inner_node_t_0* %49, i32 0, i32 1, i16 %51
  %58 = load %node_t_0*, %node_t_0** %57
  %59 = getelementptr %inner_node_t_0, %inner_node_t_0* %50, i32 0, i32 1, i16 %56
  store %node_t_0* %58, %node_t_0** %59
  %60 = getelementptr %inner_node_t_0, %inner_node_t_0* %50, i32 0, i32 1, i16 %56
  %61 = load %node_t_0*, %node_t_0** %60
  %62 = getelementptr %node_t_0, %node_t_0* %61, i32 0, i32 0, i32 0
  store %node_t_0* %10, %node_t_0** %62
  %63 = getelementptr %node_t_0, %node_t_0* %61, i32 0, i32 0, i32 1
  store i16 %56, i16* %63
  %64 = add i16 1, %51
  br label %for_begin_2
for_end_2:
  %65 = sub i16 %37, %15
  %66 = add i16 1, %65
  br label %for_begin_3
for_begin_3:
  %67 = phi i16 [0, %for_end_2], [%76, %for_body_3]
  %68 = icmp ult i16 %67, %66
  br i1 %68, label %for_body_3, label %for_end_3
for_body_3:
  %69 = add i16 %67, %15
  %70 = getelementptr %inner_node_t_0, %inner_node_t_0* %49, i32 0, i32 1, i16 %69
  %71 = load %node_t_0*, %node_t_0** %70
  %72 = getelementptr %inner_node_t_0, %inner_node_t_0* %49, i32 0, i32 1, i16 %67
  store %node_t_0* %71, %node_t_0** %72
  %73 = getelementptr %inner_node_t_0, %inner_node_t_0* %49, i32 0, i32 1, i16 %67
  %74 = load %node_t_0*, %node_t_0** %73
  %75 = getelementptr %node_t_0, %node_t_0* %74, i32 0, i32 0, i32 1
  store i16 %67, i16* %75
  %76 = add i16 1, %67
  br label %for_begin_3
for_end_3:
  br label %end_if_0
end_if_0:
  %77 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 2
  %78 = load i16, i16* %77
  %79 = add i16 %78, %15
  store i16 %79, i16* %77
  %80 = getelementptr %node_t_0, %node_t_0* %node_0, i32 0, i32 0, i32 2
  %81 = load i16, i16* %80
  %82 = sub i16 %81, %15
  store i16 %82, i16* %80
  ret i16 %15
end_if_1:
  br label %split_0
split_0:
  call ccc void @btree_node_split_0(%node_t_0* %node_0, %node_t_0** %root_0)
  ret i16 0
}

define external ccc void @btree_iterator_init_0(%btree_iterator_t_0* %iter_0, %node_t_0* %cur_0, i16 %pos_0) {
start:
  %0 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 0
  store %node_t_0* %cur_0, %node_t_0** %0
  %1 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 1
  store i16 %pos_0, i16* %1
  ret void
}

define external ccc void @btree_iterator_end_init_0(%btree_iterator_t_0* %iter_0) {
start:
  call ccc void @btree_iterator_init_0(%btree_iterator_t_0* %iter_0, %node_t_0* zeroinitializer, i16 0)
  ret void
}

define external ccc i1 @btree_iterator_is_equal_0(%btree_iterator_t_0* %lhs_0, %btree_iterator_t_0* %rhs_0) {
start:
  %0 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %lhs_0, i32 0, i32 0
  %1 = load %node_t_0*, %node_t_0** %0
  %2 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %rhs_0, i32 0, i32 0
  %3 = load %node_t_0*, %node_t_0** %2
  %4 = icmp ne %node_t_0* %1, %3
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i1 0
end_if_0:
  %5 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %lhs_0, i32 0, i32 1
  %6 = load i16, i16* %5
  %7 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %rhs_0, i32 0, i32 1
  %8 = load i16, i16* %7
  %9 = icmp eq i16 %6, %8
  ret i1 %9
}

define external ccc [2 x i32]* @btree_iterator_current_0(%btree_iterator_t_0* %iter_0) {
start:
  %0 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 1
  %1 = load i16, i16* %0
  %2 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 0
  %3 = load %node_t_0*, %node_t_0** %2
  %4 = getelementptr %node_t_0, %node_t_0* %3, i32 0, i32 1, i16 %1
  ret [2 x i32]* %4
}

define external ccc void @btree_iterator_next_0(%btree_iterator_t_0* %iter_0) {
start:
  %0 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 0
  %1 = load %node_t_0*, %node_t_0** %0
  %2 = getelementptr %node_t_0, %node_t_0* %1, i32 0, i32 0, i32 3
  %3 = load i1, i1* %2
  %4 = icmp eq i1 %3, 0
  br i1 %4, label %if_0, label %end_if_1
if_0:
  %5 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 1
  %6 = load i16, i16* %5
  %7 = add i16 1, %6
  store i16 %7, i16* %5
  %8 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 1
  %9 = load i16, i16* %8
  %10 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 0
  %11 = load %node_t_0*, %node_t_0** %10
  %12 = getelementptr %node_t_0, %node_t_0* %11, i32 0, i32 0, i32 2
  %13 = load i16, i16* %12
  %14 = icmp ult i16 %9, %13
  br i1 %14, label %if_1, label %end_if_0
if_1:
  ret void
end_if_0:
  br label %while_begin_0
while_begin_0:
  %15 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 0
  %16 = load %node_t_0*, %node_t_0** %15
  %17 = icmp eq %node_t_0* %16, zeroinitializer
  br i1 %17, label %leaf.no_parent_0, label %leaf.has_parent_0
leaf.no_parent_0:
  br label %loop.condition.end_0
leaf.has_parent_0:
  %18 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 1
  %19 = load i16, i16* %18
  %20 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 0
  %21 = load %node_t_0*, %node_t_0** %20
  %22 = getelementptr %node_t_0, %node_t_0* %21, i32 0, i32 0, i32 2
  %23 = load i16, i16* %22
  %24 = icmp eq i16 %19, %23
  br label %loop.condition.end_0
loop.condition.end_0:
  %25 = phi i1 [0, %leaf.no_parent_0], [%24, %leaf.has_parent_0]
  br i1 %25, label %while_body_0, label %while_end_0
while_body_0:
  %26 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 0
  %27 = load %node_t_0*, %node_t_0** %26
  %28 = getelementptr %node_t_0, %node_t_0* %27, i32 0, i32 0, i32 1
  %29 = load i16, i16* %28
  %30 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 1
  store i16 %29, i16* %30
  %31 = getelementptr %node_t_0, %node_t_0* %27, i32 0, i32 0, i32 0
  %32 = load %node_t_0*, %node_t_0** %31
  %33 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 0
  store %node_t_0* %32, %node_t_0** %33
  br label %while_begin_0
while_end_0:
  ret void
end_if_1:
  %34 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 1
  %35 = load i16, i16* %34
  %36 = add i16 1, %35
  %37 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 0
  %38 = load %node_t_0*, %node_t_0** %37
  %39 = bitcast %node_t_0* %38 to %inner_node_t_0*
  %40 = getelementptr %inner_node_t_0, %inner_node_t_0* %39, i32 0, i32 1, i16 %36
  %41 = load %node_t_0*, %node_t_0** %40
  %42 = alloca %node_t_0*
  store %node_t_0* %41, %node_t_0** %42
  br label %while_begin_1
while_begin_1:
  %43 = load %node_t_0*, %node_t_0** %42
  %44 = getelementptr %node_t_0, %node_t_0* %43, i32 0, i32 0, i32 3
  %45 = load i1, i1* %44
  %46 = icmp eq i1 %45, 1
  br i1 %46, label %while_body_1, label %while_end_1
while_body_1:
  %47 = load %node_t_0*, %node_t_0** %42
  %48 = bitcast %node_t_0* %47 to %inner_node_t_0*
  %49 = getelementptr %inner_node_t_0, %inner_node_t_0* %48, i32 0, i32 1, i16 0
  %50 = load %node_t_0*, %node_t_0** %49
  store %node_t_0* %50, %node_t_0** %42
  br label %while_begin_1
while_end_1:
  %51 = load %node_t_0*, %node_t_0** %42
  %52 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 0
  store %node_t_0* %51, %node_t_0** %52
  %53 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %iter_0, i32 0, i32 1
  store i16 0, i16* %53
  ret void
}

define external ccc [2 x i32]* @btree_linear_search_lower_bound_0([2 x i32]* %val_0, [2 x i32]* %current_0, [2 x i32]* %end_0) {
start:
  %0 = alloca [2 x i32]*
  store [2 x i32]* %current_0, [2 x i32]** %0
  br label %while_begin_0
while_begin_0:
  %1 = load [2 x i32]*, [2 x i32]** %0
  %2 = icmp ne [2 x i32]* %1, %end_0
  br i1 %2, label %while_body_0, label %while_end_0
while_body_0:
  %3 = load [2 x i32]*, [2 x i32]** %0
  %4 = call ccc i8 @btree_value_compare_values_0([2 x i32]* %3, [2 x i32]* %val_0)
  %5 = icmp ne i8 %4, -1
  br i1 %5, label %if_0, label %end_if_0
if_0:
  ret [2 x i32]* %3
end_if_0:
  %6 = getelementptr [2 x i32], [2 x i32]* %3, i32 1
  store [2 x i32]* %6, [2 x i32]** %0
  br label %while_begin_0
while_end_0:
  ret [2 x i32]* %end_0
}

define external ccc [2 x i32]* @btree_linear_search_upper_bound_0([2 x i32]* %val_0, [2 x i32]* %current_0, [2 x i32]* %end_0) {
start:
  %0 = alloca [2 x i32]*
  store [2 x i32]* %current_0, [2 x i32]** %0
  br label %while_begin_0
while_begin_0:
  %1 = load [2 x i32]*, [2 x i32]** %0
  %2 = icmp ne [2 x i32]* %1, %end_0
  br i1 %2, label %while_body_0, label %while_end_0
while_body_0:
  %3 = load [2 x i32]*, [2 x i32]** %0
  %4 = call ccc i8 @btree_value_compare_values_0([2 x i32]* %3, [2 x i32]* %val_0)
  %5 = icmp eq i8 %4, 1
  br i1 %5, label %if_0, label %end_if_0
if_0:
  ret [2 x i32]* %3
end_if_0:
  %6 = getelementptr [2 x i32], [2 x i32]* %3, i32 1
  store [2 x i32]* %6, [2 x i32]** %0
  br label %while_begin_0
while_end_0:
  ret [2 x i32]* %end_0
}

define external ccc void @btree_init_empty_0(%btree_t_0* %tree_0) {
start:
  %0 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 0
  store %node_t_0* zeroinitializer, %node_t_0** %0
  %1 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 1
  store %node_t_0* zeroinitializer, %node_t_0** %1
  ret void
}

define external ccc void @btree_init_0(%btree_t_0* %tree_0, %btree_iterator_t_0* %start_0, %btree_iterator_t_0* %end_0) {
start:
  call ccc void @btree_insert_range__0(%btree_t_0* %tree_0, %btree_iterator_t_0* %start_0, %btree_iterator_t_0* %end_0)
  ret void
}

define external ccc void @btree_destroy_0(%btree_t_0* %tree_0) {
start:
  call ccc void @btree_clear_0(%btree_t_0* %tree_0)
  ret void
}

define external ccc i1 @btree_is_empty_0(%btree_t_0* %tree_0) {
start:
  %0 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 0
  %1 = load %node_t_0*, %node_t_0** %0
  %2 = icmp eq %node_t_0* %1, zeroinitializer
  ret i1 %2
}

define external ccc i64 @btree_size_0(%btree_t_0* %tree_0) {
start:
  %0 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 0
  %1 = load %node_t_0*, %node_t_0** %0
  %2 = icmp eq %node_t_0* %1, zeroinitializer
  br i1 %2, label %null_0, label %not_null_0
null_0:
  ret i64 0
not_null_0:
  %3 = call ccc i64 @node_count_entries_0(%node_t_0* %1)
  ret i64 %3
}

define external ccc i1 @btree_insert_value_0(%btree_t_0* %tree_0, [2 x i32]* %val_0) {
start:
  %0 = call ccc i1 @btree_is_empty_0(%btree_t_0* %tree_0)
  br i1 %0, label %empty_0, label %non_empty_0
empty_0:
  %1 = call ccc %node_t_0* @btree_node_new_0(i1 0)
  %2 = getelementptr %node_t_0, %node_t_0* %1, i32 0, i32 0, i32 2
  store i16 1, i16* %2
  %3 = load [2 x i32], [2 x i32]* %val_0
  %4 = getelementptr %node_t_0, %node_t_0* %1, i32 0, i32 1, i16 0
  store [2 x i32] %3, [2 x i32]* %4
  %5 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 0
  store %node_t_0* %1, %node_t_0** %5
  %6 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 1
  store %node_t_0* %1, %node_t_0** %6
  br label %inserted_new_value_0
non_empty_0:
  %7 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 0
  %8 = load %node_t_0*, %node_t_0** %7
  %9 = alloca %node_t_0*
  store %node_t_0* %8, %node_t_0** %9
  br label %loop_0
loop_0:
  %10 = load %node_t_0*, %node_t_0** %9
  %11 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 3
  %12 = load i1, i1* %11
  %13 = icmp eq i1 %12, 1
  br i1 %13, label %inner_0, label %leaf_0
inner_0:
  %14 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 2
  %15 = load i16, i16* %14
  %16 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 1, i16 0
  %17 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 1, i16 %15
  %18 = call ccc [2 x i32]* @btree_linear_search_lower_bound_0([2 x i32]* %val_0, [2 x i32]* %16, [2 x i32]* %17)
  %19 = ptrtoint [2 x i32]* %18 to i64
  %20 = ptrtoint [2 x i32]* %16 to i64
  %21 = sub i64 %19, %20
  %22 = trunc i64 %21 to i16
  %23 = udiv i16 %22, 8
  %24 = icmp ne [2 x i32]* %18, %17
  %25 = getelementptr [2 x i32], [2 x i32]* %18, i32 0
  %26 = call ccc i8 @btree_value_compare_values_0([2 x i32]* %25, [2 x i32]* %val_0)
  %27 = icmp eq i8 0, %26
  %28 = and i1 %24, %27
  br i1 %28, label %no_insert_0, label %inner_continue_insert_0
inner_continue_insert_0:
  %29 = bitcast %node_t_0* %10 to %inner_node_t_0*
  %30 = getelementptr %inner_node_t_0, %inner_node_t_0* %29, i32 0, i32 1, i16 %23
  %31 = load %node_t_0*, %node_t_0** %30
  store %node_t_0* %31, %node_t_0** %9
  br label %loop_0
leaf_0:
  %32 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 2
  %33 = load i16, i16* %32
  %34 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 1, i16 0
  %35 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 1, i16 %33
  %36 = call ccc [2 x i32]* @btree_linear_search_upper_bound_0([2 x i32]* %val_0, [2 x i32]* %34, [2 x i32]* %35)
  %37 = ptrtoint [2 x i32]* %36 to i64
  %38 = ptrtoint [2 x i32]* %34 to i64
  %39 = sub i64 %37, %38
  %40 = trunc i64 %39 to i16
  %41 = udiv i16 %40, 8
  %42 = alloca i16
  store i16 %41, i16* %42
  %43 = icmp ne [2 x i32]* %36, %34
  %44 = getelementptr [2 x i32], [2 x i32]* %36, i32 -1
  %45 = call ccc i8 @btree_value_compare_values_0([2 x i32]* %44, [2 x i32]* %val_0)
  %46 = icmp eq i8 0, %45
  %47 = and i1 %43, %46
  br i1 %47, label %no_insert_0, label %leaf_continue_insert_0
leaf_continue_insert_0:
  %48 = icmp uge i16 %33, 30
  br i1 %48, label %split_0, label %no_split_0
split_0:
  %49 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 0
  %50 = load i16, i16* %42
  %51 = call ccc i16 @btree_node_rebalance_or_split_0(%node_t_0* %10, %node_t_0** %49, i16 %50)
  %52 = sub i16 %50, %51
  store i16 %52, i16* %42
  %53 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 2
  %54 = load i16, i16* %53
  %55 = icmp ugt i16 %52, %54
  br i1 %55, label %if_0, label %end_if_0
if_0:
  %56 = add i16 %54, 1
  %57 = sub i16 %52, %56
  store i16 %57, i16* %42
  %58 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 0
  %59 = load %node_t_0*, %node_t_0** %58
  %60 = bitcast %node_t_0* %59 to %inner_node_t_0*
  %61 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 1
  %62 = load i16, i16* %61
  %63 = add i16 1, %62
  %64 = getelementptr %inner_node_t_0, %inner_node_t_0* %60, i32 0, i32 1, i16 %63
  %65 = load %node_t_0*, %node_t_0** %64
  store %node_t_0* %65, %node_t_0** %9
  br label %end_if_0
end_if_0:
  br label %no_split_0
no_split_0:
  %66 = load i16, i16* %42
  %67 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 2
  %68 = load i16, i16* %67
  br label %for_begin_0
for_begin_0:
  %69 = phi i16 [%68, %no_split_0], [%75, %for_body_0]
  %70 = icmp ugt i16 %69, %66
  br i1 %70, label %for_body_0, label %for_end_0
for_body_0:
  %71 = sub i16 %69, 1
  %72 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 1, i16 %71
  %73 = load [2 x i32], [2 x i32]* %72
  %74 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 1, i16 %69
  store [2 x i32] %73, [2 x i32]* %74
  %75 = sub i16 %69, 1
  br label %for_begin_0
for_end_0:
  %76 = load [2 x i32], [2 x i32]* %val_0
  %77 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 1, i16 %66
  store [2 x i32] %76, [2 x i32]* %77
  %78 = getelementptr %node_t_0, %node_t_0* %10, i32 0, i32 0, i32 2
  %79 = load i16, i16* %78
  %80 = add i16 1, %79
  store i16 %80, i16* %78
  br label %inserted_new_value_0
no_insert_0:
  ret i1 0
inserted_new_value_0:
  ret i1 1
}

define external ccc void @btree_insert_range__0(%btree_t_0* %tree_0, %btree_iterator_t_0* %begin_0, %btree_iterator_t_0* %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @btree_iterator_is_equal_0(%btree_iterator_t_0* %begin_0, %btree_iterator_t_0* %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc [2 x i32]* @btree_iterator_current_0(%btree_iterator_t_0* %begin_0)
  %3 = call ccc i1 @btree_insert_value_0(%btree_t_0* %tree_0, [2 x i32]* %2)
  call ccc void @btree_iterator_next_0(%btree_iterator_t_0* %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @btree_begin_0(%btree_t_0* %tree_0, %btree_iterator_t_0* %result_0) {
start:
  %0 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 1
  %1 = load %node_t_0*, %node_t_0** %0
  %2 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %result_0, i32 0, i32 0
  store %node_t_0* %1, %node_t_0** %2
  %3 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %result_0, i32 0, i32 1
  store i16 0, i16* %3
  ret void
}

define external ccc void @btree_end_0(%btree_t_0* %tree_0, %btree_iterator_t_0* %result_0) {
start:
  call ccc void @btree_iterator_end_init_0(%btree_iterator_t_0* %result_0)
  ret void
}

define external ccc i1 @btree_contains_0(%btree_t_0* %tree_0, [2 x i32]* %val_0) {
start:
  %0 = alloca %btree_iterator_t_0, i32 1
  %1 = alloca %btree_iterator_t_0, i32 1
  call ccc void @btree_find_0(%btree_t_0* %tree_0, [2 x i32]* %val_0, %btree_iterator_t_0* %0)
  call ccc void @btree_end_0(%btree_t_0* %tree_0, %btree_iterator_t_0* %1)
  %2 = call ccc i1 @btree_iterator_is_equal_0(%btree_iterator_t_0* %0, %btree_iterator_t_0* %1)
  %3 = select i1 %2, i1 0, i1 1
  ret i1 %3
}

define external ccc void @btree_find_0(%btree_t_0* %tree_0, [2 x i32]* %val_0, %btree_iterator_t_0* %result_0) {
start:
  %0 = call ccc i1 @btree_is_empty_0(%btree_t_0* %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @btree_iterator_end_init_0(%btree_iterator_t_0* %result_0)
  ret void
end_if_0:
  %1 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 0
  %2 = load %node_t_0*, %node_t_0** %1
  %3 = alloca %node_t_0*
  store %node_t_0* %2, %node_t_0** %3
  br label %loop_0
loop_0:
  %4 = load %node_t_0*, %node_t_0** %3
  %5 = getelementptr %node_t_0, %node_t_0* %4, i32 0, i32 0, i32 2
  %6 = load i16, i16* %5
  %7 = getelementptr %node_t_0, %node_t_0* %4, i32 0, i32 1, i16 0
  %8 = getelementptr %node_t_0, %node_t_0* %4, i32 0, i32 1, i16 %6
  %9 = call ccc [2 x i32]* @btree_linear_search_lower_bound_0([2 x i32]* %val_0, [2 x i32]* %7, [2 x i32]* %8)
  %10 = ptrtoint [2 x i32]* %9 to i64
  %11 = ptrtoint [2 x i32]* %7 to i64
  %12 = sub i64 %10, %11
  %13 = trunc i64 %12 to i16
  %14 = udiv i16 %13, 8
  %15 = icmp ult [2 x i32]* %9, %8
  %16 = call ccc i8 @btree_value_compare_values_0([2 x i32]* %9, [2 x i32]* %val_0)
  %17 = icmp eq i8 0, %16
  %18 = and i1 %15, %17
  br i1 %18, label %if_1, label %end_if_1
if_1:
  call ccc void @btree_iterator_init_0(%btree_iterator_t_0* %result_0, %node_t_0* %4, i16 %14)
  ret void
end_if_1:
  %19 = getelementptr %node_t_0, %node_t_0* %4, i32 0, i32 0, i32 3
  %20 = load i1, i1* %19
  %21 = icmp eq i1 %20, 0
  br i1 %21, label %if_2, label %end_if_2
if_2:
  call ccc void @btree_iterator_end_init_0(%btree_iterator_t_0* %result_0)
  ret void
end_if_2:
  %22 = bitcast %node_t_0* %4 to %inner_node_t_0*
  %23 = getelementptr %inner_node_t_0, %inner_node_t_0* %22, i32 0, i32 1, i16 %14
  %24 = load %node_t_0*, %node_t_0** %23
  store %node_t_0* %24, %node_t_0** %3
  br label %loop_0
}

define external ccc void @btree_lower_bound_0(%btree_t_0* %tree_0, [2 x i32]* %val_0, %btree_iterator_t_0* %result_0) {
start:
  %0 = call ccc i1 @btree_is_empty_0(%btree_t_0* %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @btree_iterator_end_init_0(%btree_iterator_t_0* %result_0)
  ret void
end_if_0:
  %1 = alloca %btree_iterator_t_0, i32 1
  call ccc void @btree_iterator_end_init_0(%btree_iterator_t_0* %1)
  %2 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 0
  %3 = load %node_t_0*, %node_t_0** %2
  %4 = alloca %node_t_0*
  store %node_t_0* %3, %node_t_0** %4
  br label %loop_0
loop_0:
  %5 = load %node_t_0*, %node_t_0** %4
  %6 = getelementptr %node_t_0, %node_t_0* %5, i32 0, i32 0, i32 2
  %7 = load i16, i16* %6
  %8 = getelementptr %node_t_0, %node_t_0* %5, i32 0, i32 1, i16 0
  %9 = getelementptr %node_t_0, %node_t_0* %5, i32 0, i32 1, i16 %7
  %10 = call ccc [2 x i32]* @btree_linear_search_lower_bound_0([2 x i32]* %val_0, [2 x i32]* %8, [2 x i32]* %9)
  %11 = ptrtoint [2 x i32]* %10 to i64
  %12 = ptrtoint [2 x i32]* %8 to i64
  %13 = sub i64 %11, %12
  %14 = trunc i64 %13 to i16
  %15 = udiv i16 %14, 8
  %16 = getelementptr %node_t_0, %node_t_0* %5, i32 0, i32 0, i32 3
  %17 = load i1, i1* %16
  %18 = icmp eq i1 %17, 0
  br i1 %18, label %if_1, label %end_if_1
if_1:
  %19 = icmp eq [2 x i32]* %10, %9
  br i1 %19, label %handle_last_0, label %handle_not_last_0
handle_last_0:
  %20 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %1, i32 0, i32 0
  %21 = load %node_t_0*, %node_t_0** %20
  %22 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %result_0, i32 0, i32 0
  store %node_t_0* %21, %node_t_0** %22
  %23 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %1, i32 0, i32 1
  %24 = load i16, i16* %23
  %25 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %result_0, i32 0, i32 1
  store i16 %24, i16* %25
  ret void
handle_not_last_0:
  call ccc void @btree_iterator_init_0(%btree_iterator_t_0* %result_0, %node_t_0* %5, i16 %15)
  ret void
end_if_1:
  %26 = icmp ne [2 x i32]* %10, %9
  %27 = call ccc i8 @btree_value_compare_values_0([2 x i32]* %10, [2 x i32]* %val_0)
  %28 = icmp eq i8 0, %27
  %29 = and i1 %26, %28
  br i1 %29, label %if_2, label %end_if_2
if_2:
  call ccc void @btree_iterator_init_0(%btree_iterator_t_0* %result_0, %node_t_0* %5, i16 %15)
  ret void
end_if_2:
  br i1 %26, label %if_3, label %end_if_3
if_3:
  call ccc void @btree_iterator_init_0(%btree_iterator_t_0* %1, %node_t_0* %5, i16 %15)
  br label %end_if_3
end_if_3:
  %30 = bitcast %node_t_0* %5 to %inner_node_t_0*
  %31 = getelementptr %inner_node_t_0, %inner_node_t_0* %30, i32 0, i32 1, i16 %15
  %32 = load %node_t_0*, %node_t_0** %31
  store %node_t_0* %32, %node_t_0** %4
  br label %loop_0
}

define external ccc void @btree_upper_bound_0(%btree_t_0* %tree_0, [2 x i32]* %val_0, %btree_iterator_t_0* %result_0) {
start:
  %0 = call ccc i1 @btree_is_empty_0(%btree_t_0* %tree_0)
  br i1 %0, label %if_0, label %end_if_0
if_0:
  call ccc void @btree_iterator_end_init_0(%btree_iterator_t_0* %result_0)
  ret void
end_if_0:
  %1 = alloca %btree_iterator_t_0, i32 1
  call ccc void @btree_iterator_end_init_0(%btree_iterator_t_0* %1)
  %2 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 0
  %3 = load %node_t_0*, %node_t_0** %2
  %4 = alloca %node_t_0*
  store %node_t_0* %3, %node_t_0** %4
  br label %loop_0
loop_0:
  %5 = load %node_t_0*, %node_t_0** %4
  %6 = getelementptr %node_t_0, %node_t_0* %5, i32 0, i32 0, i32 2
  %7 = load i16, i16* %6
  %8 = getelementptr %node_t_0, %node_t_0* %5, i32 0, i32 1, i16 0
  %9 = getelementptr %node_t_0, %node_t_0* %5, i32 0, i32 1, i16 %7
  %10 = call ccc [2 x i32]* @btree_linear_search_upper_bound_0([2 x i32]* %val_0, [2 x i32]* %8, [2 x i32]* %9)
  %11 = ptrtoint [2 x i32]* %10 to i64
  %12 = ptrtoint [2 x i32]* %8 to i64
  %13 = sub i64 %11, %12
  %14 = trunc i64 %13 to i16
  %15 = udiv i16 %14, 8
  %16 = getelementptr %node_t_0, %node_t_0* %5, i32 0, i32 0, i32 3
  %17 = load i1, i1* %16
  %18 = icmp eq i1 %17, 0
  br i1 %18, label %if_1, label %end_if_1
if_1:
  %19 = icmp eq [2 x i32]* %10, %9
  br i1 %19, label %handle_last_0, label %handle_not_last_0
handle_last_0:
  %20 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %1, i32 0, i32 0
  %21 = load %node_t_0*, %node_t_0** %20
  %22 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %result_0, i32 0, i32 0
  store %node_t_0* %21, %node_t_0** %22
  %23 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %1, i32 0, i32 1
  %24 = load i16, i16* %23
  %25 = getelementptr %btree_iterator_t_0, %btree_iterator_t_0* %result_0, i32 0, i32 1
  store i16 %24, i16* %25
  ret void
handle_not_last_0:
  call ccc void @btree_iterator_init_0(%btree_iterator_t_0* %result_0, %node_t_0* %5, i16 %15)
  ret void
end_if_1:
  %26 = icmp ne [2 x i32]* %10, %9
  br i1 %26, label %if_2, label %end_if_2
if_2:
  call ccc void @btree_iterator_init_0(%btree_iterator_t_0* %result_0, %node_t_0* %5, i16 %15)
  br label %end_if_2
end_if_2:
  %27 = bitcast %node_t_0* %5 to %inner_node_t_0*
  %28 = getelementptr %inner_node_t_0, %inner_node_t_0* %27, i32 0, i32 1, i16 %15
  %29 = load %node_t_0*, %node_t_0** %28
  store %node_t_0* %29, %node_t_0** %4
  br label %loop_0
}

define external ccc void @btree_clear_0(%btree_t_0* %tree_0) {
start:
  %0 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 0
  %1 = load %node_t_0*, %node_t_0** %0
  %2 = icmp ne %node_t_0* %1, zeroinitializer
  br i1 %2, label %if_0, label %end_if_0
if_0:
  call ccc void @btree_node_delete_0(%node_t_0* %1)
  %3 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 0
  store %node_t_0* zeroinitializer, %node_t_0** %3
  %4 = getelementptr %btree_t_0, %btree_t_0* %tree_0, i32 0, i32 1
  store %node_t_0* zeroinitializer, %node_t_0** %4
  br label %end_if_0
end_if_0:
  ret void
}

define external ccc void @btree_swap_0(%btree_t_0* %lhs_0, %btree_t_0* %rhs_0) {
start:
  %0 = getelementptr %btree_t_0, %btree_t_0* %lhs_0, i32 0, i32 0
  %1 = load %node_t_0*, %node_t_0** %0
  %2 = getelementptr %btree_t_0, %btree_t_0* %rhs_0, i32 0, i32 0
  %3 = load %node_t_0*, %node_t_0** %2
  %4 = getelementptr %btree_t_0, %btree_t_0* %lhs_0, i32 0, i32 0
  store %node_t_0* %3, %node_t_0** %4
  %5 = getelementptr %btree_t_0, %btree_t_0* %rhs_0, i32 0, i32 0
  store %node_t_0* %1, %node_t_0** %5
  %6 = getelementptr %btree_t_0, %btree_t_0* %lhs_0, i32 0, i32 1
  %7 = load %node_t_0*, %node_t_0** %6
  %8 = getelementptr %btree_t_0, %btree_t_0* %rhs_0, i32 0, i32 1
  %9 = load %node_t_0*, %node_t_0** %8
  %10 = getelementptr %btree_t_0, %btree_t_0* %lhs_0, i32 0, i32 1
  store %node_t_0* %9, %node_t_0** %10
  %11 = getelementptr %btree_t_0, %btree_t_0* %rhs_0, i32 0, i32 1
  store %node_t_0* %7, %node_t_0** %11
  ret void
}

@specialize_debug_info.btree__2__0_1__256__linear = global i32 0

%symbol_t = type <{i32, i8*}>

define external ccc void @symbol_init(%symbol_t* %symbol_0, i32 %size_0, i8* %data_0) {
start:
  %0 = getelementptr %symbol_t, %symbol_t* %symbol_0, i32 0, i32 0
  store i32 %size_0, i32* %0
  %1 = getelementptr %symbol_t, %symbol_t* %symbol_0, i32 0, i32 1
  store i8* %data_0, i8** %1
  ret void
}

define external ccc void @symbol_destroy(%symbol_t* %symbol_0) {
start:
  %0 = getelementptr %symbol_t, %symbol_t* %symbol_0, i32 0, i32 1
  %1 = load i8*, i8** %0
  call ccc void @free(i8* %1)
  ret void
}

define external ccc i1 @symbol_is_equal(%symbol_t* %symbol1_0, %symbol_t* %symbol2_0) {
start:
  %0 = getelementptr %symbol_t, %symbol_t* %symbol1_0, i32 0, i32 0
  %1 = load i32, i32* %0
  %2 = getelementptr %symbol_t, %symbol_t* %symbol2_0, i32 0, i32 0
  %3 = load i32, i32* %2
  %4 = icmp ne i32 %1, %3
  br i1 %4, label %if_0, label %end_if_0
if_0:
  ret i1 0
end_if_0:
  %5 = getelementptr %symbol_t, %symbol_t* %symbol1_0, i32 0, i32 1
  %6 = load i8*, i8** %5
  %7 = getelementptr %symbol_t, %symbol_t* %symbol2_0, i32 0, i32 1
  %8 = load i8*, i8** %7
  %9 = zext i32 %1 to i64
  %10 = call ccc i32 @memcmp(i8* %6, i8* %8, i64 %9)
  %11 = icmp eq i32 %10, 0
  ret i1 %11
}

%vector_t_symbol = type {%symbol_t*, %symbol_t*, i32}

define external ccc void @vector_init_symbol(%vector_t_symbol* %vec_0) {
start:
  %0 = call ccc i8* @malloc(i32 192)
  %1 = bitcast i8* %0 to %symbol_t*
  %2 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 0
  store %symbol_t* %1, %symbol_t** %2
  %3 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 1
  store %symbol_t* %1, %symbol_t** %3
  %4 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 2
  store i32 16, i32* %4
  ret void
}

define external ccc void @vector_destroy_symbol(%vector_t_symbol* %vec_0) {
start:
  %0 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 0
  %1 = load %symbol_t*, %symbol_t** %0
  %2 = alloca %symbol_t*
  store %symbol_t* %1, %symbol_t** %2
  br label %while_begin_0
while_begin_0:
  %3 = load %symbol_t*, %symbol_t** %2
  %4 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 1
  %5 = load %symbol_t*, %symbol_t** %4
  %6 = icmp ne %symbol_t* %3, %5
  br i1 %6, label %while_body_0, label %while_end_0
while_body_0:
  %7 = load %symbol_t*, %symbol_t** %2
  call ccc void @symbol_destroy(%symbol_t* %7)
  %8 = getelementptr %symbol_t, %symbol_t* %7, i32 1
  store %symbol_t* %8, %symbol_t** %2
  br label %while_begin_0
while_end_0:
  %9 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 0
  %10 = load %symbol_t*, %symbol_t** %9
  %11 = bitcast %symbol_t* %10 to i8*
  call ccc void @free(i8* %11)
  ret void
}

define external ccc i32 @vector_size_symbol(%vector_t_symbol* %vec_0) {
start:
  %0 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 0
  %1 = load %symbol_t*, %symbol_t** %0
  %2 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 1
  %3 = load %symbol_t*, %symbol_t** %2
  %4 = ptrtoint %symbol_t* %3 to i64
  %5 = ptrtoint %symbol_t* %1 to i64
  %6 = sub i64 %4, %5
  %7 = trunc i64 %6 to i32
  %8 = udiv i32 %7, 12
  ret i32 %8
}

define external ccc void @vector_grow_symbol(%vector_t_symbol* %vec_0) {
start:
  %0 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 2
  %1 = load i32, i32* %0
  %2 = mul i32 %1, 12
  %3 = zext i32 %2 to i64
  %4 = mul i32 %1, 2
  %5 = mul i32 %4, 12
  %6 = call ccc i8* @malloc(i32 %5)
  %7 = bitcast i8* %6 to %symbol_t*
  %8 = getelementptr %symbol_t, %symbol_t* %7, i32 %1
  %9 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 0
  %10 = load %symbol_t*, %symbol_t** %9
  %11 = bitcast %symbol_t* %10 to i8*
  %12 = bitcast %symbol_t* %7 to i8*
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(i8* %12, i8* %11, i64 %3, i1 0)
  call ccc void @free(i8* %11)
  %13 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 0
  store %symbol_t* %7, %symbol_t** %13
  %14 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 1
  store %symbol_t* %8, %symbol_t** %14
  %15 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 2
  store i32 %4, i32* %15
  ret void
}

define external ccc i32 @vector_push_symbol(%vector_t_symbol* %vec_0, %symbol_t* %elem_0) {
start:
  %0 = call ccc i32 @vector_size_symbol(%vector_t_symbol* %vec_0)
  %1 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 2
  %2 = load i32, i32* %1
  %3 = icmp eq i32 %0, %2
  br i1 %3, label %if_0, label %end_if_0
if_0:
  call ccc void @vector_grow_symbol(%vector_t_symbol* %vec_0)
  br label %end_if_0
end_if_0:
  %4 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 1
  %5 = load %symbol_t*, %symbol_t** %4
  %6 = load %symbol_t, %symbol_t* %elem_0
  store %symbol_t %6, %symbol_t* %5
  %7 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 1
  %8 = load %symbol_t*, %symbol_t** %7
  %9 = getelementptr %symbol_t, %symbol_t* %8, i32 1
  store %symbol_t* %9, %symbol_t** %7
  ret i32 %0
}

define external ccc %symbol_t* @vector_get_value_symbol(%vector_t_symbol* %vec_0, i32 %idx_0) {
start:
  %0 = getelementptr %vector_t_symbol, %vector_t_symbol* %vec_0, i32 0, i32 0
  %1 = load %symbol_t*, %symbol_t** %0
  %2 = getelementptr %symbol_t, %symbol_t* %1, i32 %idx_0
  ret %symbol_t* %2
}

%entry_t = type {%symbol_t, i32}

%vector_t_entry = type {%entry_t*, %entry_t*, i32}

define external ccc void @vector_init_entry(%vector_t_entry* %vec_0) {
start:
  %0 = call ccc i8* @malloc(i32 256)
  %1 = bitcast i8* %0 to %entry_t*
  %2 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 0
  store %entry_t* %1, %entry_t** %2
  %3 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 1
  store %entry_t* %1, %entry_t** %3
  %4 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 2
  store i32 16, i32* %4
  ret void
}

define external ccc void @vector_destroy_entry(%vector_t_entry* %vec_0) {
start:
  %0 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 0
  %1 = load %entry_t*, %entry_t** %0
  %2 = bitcast %entry_t* %1 to i8*
  call ccc void @free(i8* %2)
  ret void
}

define external ccc i32 @vector_size_entry(%vector_t_entry* %vec_0) {
start:
  %0 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 0
  %1 = load %entry_t*, %entry_t** %0
  %2 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 1
  %3 = load %entry_t*, %entry_t** %2
  %4 = ptrtoint %entry_t* %3 to i64
  %5 = ptrtoint %entry_t* %1 to i64
  %6 = sub i64 %4, %5
  %7 = trunc i64 %6 to i32
  %8 = udiv i32 %7, 16
  ret i32 %8
}

define external ccc void @vector_grow_entry(%vector_t_entry* %vec_0) {
start:
  %0 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 2
  %1 = load i32, i32* %0
  %2 = mul i32 %1, 16
  %3 = zext i32 %2 to i64
  %4 = mul i32 %1, 2
  %5 = mul i32 %4, 16
  %6 = call ccc i8* @malloc(i32 %5)
  %7 = bitcast i8* %6 to %entry_t*
  %8 = getelementptr %entry_t, %entry_t* %7, i32 %1
  %9 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 0
  %10 = load %entry_t*, %entry_t** %9
  %11 = bitcast %entry_t* %10 to i8*
  %12 = bitcast %entry_t* %7 to i8*
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(i8* %12, i8* %11, i64 %3, i1 0)
  call ccc void @free(i8* %11)
  %13 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 0
  store %entry_t* %7, %entry_t** %13
  %14 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 1
  store %entry_t* %8, %entry_t** %14
  %15 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 2
  store i32 %4, i32* %15
  ret void
}

define external ccc i32 @vector_push_entry(%vector_t_entry* %vec_0, %entry_t* %elem_0) {
start:
  %0 = call ccc i32 @vector_size_entry(%vector_t_entry* %vec_0)
  %1 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 2
  %2 = load i32, i32* %1
  %3 = icmp eq i32 %0, %2
  br i1 %3, label %if_0, label %end_if_0
if_0:
  call ccc void @vector_grow_entry(%vector_t_entry* %vec_0)
  br label %end_if_0
end_if_0:
  %4 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 1
  %5 = load %entry_t*, %entry_t** %4
  %6 = load %entry_t, %entry_t* %elem_0
  store %entry_t %6, %entry_t* %5
  %7 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 1
  %8 = load %entry_t*, %entry_t** %7
  %9 = getelementptr %entry_t, %entry_t* %8, i32 1
  store %entry_t* %9, %entry_t** %7
  ret i32 %0
}

define external ccc %entry_t* @vector_get_value_entry(%vector_t_entry* %vec_0, i32 %idx_0) {
start:
  %0 = getelementptr %vector_t_entry, %vector_t_entry* %vec_0, i32 0, i32 0
  %1 = load %entry_t*, %entry_t** %0
  %2 = getelementptr %entry_t, %entry_t* %1, i32 %idx_0
  ret %entry_t* %2
}

%hashmap_t = type {[64 x %vector_t_entry]}

define external ccc i32 @symbol_hash(%symbol_t* %symbol_0) {
start:
  %0 = alloca i32
  store i32 0, i32* %0
  %1 = getelementptr %symbol_t, %symbol_t* %symbol_0, i32 0, i32 0
  %2 = load i32, i32* %1
  %3 = getelementptr %symbol_t, %symbol_t* %symbol_0, i32 0, i32 1
  %4 = load i8*, i8** %3
  br label %for_begin_0
for_begin_0:
  %5 = phi i32 [0, %start], [%13, %for_body_0]
  %6 = icmp ult i32 %5, %2
  br i1 %6, label %for_body_0, label %for_end_0
for_body_0:
  %7 = getelementptr i8, i8* %4, i32 %5
  %8 = load i8, i8* %7
  %9 = zext i8 %8 to i32
  %10 = load i32, i32* %0
  %11 = mul i32 31, %10
  %12 = add i32 %9, %11
  store i32 %12, i32* %0
  %13 = add i32 1, %5
  br label %for_begin_0
for_end_0:
  %14 = load i32, i32* %0
  %15 = and i32 %14, 63
  ret i32 %15
}

define external ccc void @hashmap_init(%hashmap_t* %hashmap_0) {
start:
  br label %for_begin_0
for_begin_0:
  %0 = phi i32 [0, %start], [%3, %for_body_0]
  %1 = icmp ult i32 %0, 64
  br i1 %1, label %for_body_0, label %for_end_0
for_body_0:
  %2 = getelementptr %hashmap_t, %hashmap_t* %hashmap_0, i32 0, i32 0, i32 %0
  call ccc void @vector_init_entry(%vector_t_entry* %2)
  %3 = add i32 1, %0
  br label %for_begin_0
for_end_0:
  ret void
}

define external ccc void @hashmap_destroy(%hashmap_t* %hashmap_0) {
start:
  br label %for_begin_0
for_begin_0:
  %0 = phi i32 [0, %start], [%3, %for_body_0]
  %1 = icmp ult i32 %0, 64
  br i1 %1, label %for_body_0, label %for_end_0
for_body_0:
  %2 = getelementptr %hashmap_t, %hashmap_t* %hashmap_0, i32 0, i32 0, i32 %0
  call ccc void @vector_destroy_entry(%vector_t_entry* %2)
  %3 = add i32 1, %0
  br label %for_begin_0
for_end_0:
  ret void
}

define external ccc i32 @hashmap_get_or_put_value(%hashmap_t* %hashmap_0, %symbol_t* %symbol_0, i32 %value_0) {
start:
  %0 = call ccc i32 @symbol_hash(%symbol_t* %symbol_0)
  %1 = and i32 %0, 63
  %2 = getelementptr %hashmap_t, %hashmap_t* %hashmap_0, i32 0, i32 0, i32 %1
  %3 = call ccc i32 @vector_size_entry(%vector_t_entry* %2)
  br label %for_begin_0
for_begin_0:
  %4 = phi i32 [0, %start], [%11, %end_if_0]
  %5 = icmp ult i32 %4, %3
  br i1 %5, label %for_body_0, label %for_end_0
for_body_0:
  %6 = call ccc %entry_t* @vector_get_value_entry(%vector_t_entry* %2, i32 %4)
  %7 = getelementptr %entry_t, %entry_t* %6, i32 0, i32 0
  %8 = call ccc i1 @symbol_is_equal(%symbol_t* %7, %symbol_t* %symbol_0)
  br i1 %8, label %if_0, label %end_if_0
if_0:
  %9 = getelementptr %entry_t, %entry_t* %6, i32 0, i32 1
  %10 = load i32, i32* %9
  ret i32 %10
end_if_0:
  %11 = add i32 1, %4
  br label %for_begin_0
for_end_0:
  %12 = load %symbol_t, %symbol_t* %symbol_0
  %13 = alloca %entry_t
  %14 = getelementptr %entry_t, %entry_t* %13, i32 0, i32 0
  store %symbol_t %12, %symbol_t* %14
  %15 = getelementptr %entry_t, %entry_t* %13, i32 0, i32 1
  store i32 %value_0, i32* %15
  %16 = call ccc i32 @vector_push_entry(%vector_t_entry* %2, %entry_t* %13)
  ret i32 %value_0
}

define external ccc i32 @hashmap_lookup(%hashmap_t* %hashmap_0, %symbol_t* %symbol_0) {
start:
  %0 = call ccc i32 @symbol_hash(%symbol_t* %symbol_0)
  %1 = and i32 %0, 63
  %2 = getelementptr %hashmap_t, %hashmap_t* %hashmap_0, i32 0, i32 0, i32 %1
  %3 = call ccc i32 @vector_size_entry(%vector_t_entry* %2)
  br label %for_begin_0
for_begin_0:
  %4 = phi i32 [0, %start], [%11, %end_if_0]
  %5 = icmp ult i32 %4, %3
  br i1 %5, label %for_body_0, label %for_end_0
for_body_0:
  %6 = call ccc %entry_t* @vector_get_value_entry(%vector_t_entry* %2, i32 %4)
  %7 = getelementptr %entry_t, %entry_t* %6, i32 0, i32 0
  %8 = call ccc i1 @symbol_is_equal(%symbol_t* %7, %symbol_t* %symbol_0)
  br i1 %8, label %if_0, label %end_if_0
if_0:
  %9 = getelementptr %entry_t, %entry_t* %6, i32 0, i32 1
  %10 = load i32, i32* %9
  ret i32 %10
end_if_0:
  %11 = add i32 1, %4
  br label %for_begin_0
for_end_0:
  ret i32 4294967295
}

define external ccc i1 @hashmap_contains(%hashmap_t* %hashmap_0, %symbol_t* %symbol_0) {
start:
  %0 = call ccc i32 @symbol_hash(%symbol_t* %symbol_0)
  %1 = and i32 %0, 63
  %2 = getelementptr %hashmap_t, %hashmap_t* %hashmap_0, i32 0, i32 0, i32 %1
  %3 = call ccc i32 @vector_size_entry(%vector_t_entry* %2)
  br label %for_begin_0
for_begin_0:
  %4 = phi i32 [0, %start], [%9, %end_if_0]
  %5 = icmp ult i32 %4, %3
  br i1 %5, label %for_body_0, label %for_end_0
for_body_0:
  %6 = call ccc %entry_t* @vector_get_value_entry(%vector_t_entry* %2, i32 %4)
  %7 = getelementptr %entry_t, %entry_t* %6, i32 0, i32 0
  %8 = call ccc i1 @symbol_is_equal(%symbol_t* %7, %symbol_t* %symbol_0)
  br i1 %8, label %if_0, label %end_if_0
if_0:
  ret i1 1
end_if_0:
  %9 = add i32 1, %4
  br label %for_begin_0
for_end_0:
  ret i1 0
}

%symbol_table = type {%vector_t_symbol, %hashmap_t}

define external ccc void @symbol_table_init(%symbol_table* %table_0) {
start:
  %0 = getelementptr %symbol_table, %symbol_table* %table_0, i32 0, i32 0
  %1 = getelementptr %symbol_table, %symbol_table* %table_0, i32 0, i32 1
  call ccc void @vector_init_symbol(%vector_t_symbol* %0)
  call ccc void @hashmap_init(%hashmap_t* %1)
  ret void
}

define external ccc void @symbol_table_destroy(%symbol_table* %table_0) {
start:
  %0 = getelementptr %symbol_table, %symbol_table* %table_0, i32 0, i32 0
  %1 = getelementptr %symbol_table, %symbol_table* %table_0, i32 0, i32 1
  call ccc void @vector_destroy_symbol(%vector_t_symbol* %0)
  call ccc void @hashmap_destroy(%hashmap_t* %1)
  ret void
}

define external ccc i32 @symbol_table_find_or_insert(%symbol_table* %table_0, %symbol_t* %symbol_0) {
start:
  %0 = getelementptr %symbol_table, %symbol_table* %table_0, i32 0, i32 0
  %1 = getelementptr %symbol_table, %symbol_table* %table_0, i32 0, i32 1
  %2 = call ccc i32 @vector_size_symbol(%vector_t_symbol* %0)
  %3 = call ccc i32 @hashmap_get_or_put_value(%hashmap_t* %1, %symbol_t* %symbol_0, i32 %2)
  %4 = icmp eq i32 %2, %3
  br i1 %4, label %if_0, label %end_if_0
if_0:
  %5 = call ccc i32 @vector_push_symbol(%vector_t_symbol* %0, %symbol_t* %symbol_0)
  br label %end_if_0
end_if_0:
  ret i32 %3
}

define external ccc i1 @symbol_table_contains_index(%symbol_table* %table_0, i32 %index_0) {
start:
  %0 = getelementptr %symbol_table, %symbol_table* %table_0, i32 0, i32 0
  %1 = call ccc i32 @vector_size_symbol(%vector_t_symbol* %0)
  %2 = icmp ult i32 %index_0, %1
  ret i1 %2
}

define external ccc i1 @symbol_table_contains_symbol(%symbol_table* %table_0, %symbol_t* %symbol_0) {
start:
  %0 = getelementptr %symbol_table, %symbol_table* %table_0, i32 0, i32 1
  %1 = call ccc i1 @hashmap_contains(%hashmap_t* %0, %symbol_t* %symbol_0)
  ret i1 %1
}

define external ccc i32 @symbol_table_lookup_index(%symbol_table* %table_0, %symbol_t* %symbol_0) {
start:
  %0 = getelementptr %symbol_table, %symbol_table* %table_0, i32 0, i32 1
  %1 = call ccc i32 @hashmap_lookup(%hashmap_t* %0, %symbol_t* %symbol_0)
  ret i32 %1
}

define external ccc %symbol_t* @symbol_table_lookup_symbol(%symbol_table* %table_0, i32 %index_0) {
start:
  %0 = getelementptr %symbol_table, %symbol_table* %table_0, i32 0, i32 0
  %1 = call ccc %symbol_t* @vector_get_value_symbol(%vector_t_symbol* %0, i32 %index_0)
  ret %symbol_t* %1
}

%program = type {%symbol_table, %btree_t_0, %btree_t_0, %btree_t_0, %btree_t_0, %btree_t_0, %btree_t_0}

@string_literal_0 = global [3 x i8] [i8 120, i8 49, i8 0]

@string_literal_1 = global [3 x i8] [i8 120, i8 50, i8 0]

@string_literal_2 = global [5 x i8] [i8 69, i8 100, i8 103, i8 101, i8 0]

@string_literal_3 = global [10 x i8] [i8 82, i8 101, i8 97, i8 99, i8 104, i8 97, i8 98, i8 108, i8 101, i8 0]

define external ccc %program* @eclair_program_init() "wasm-export-name"="eclair_program_init" {
start:
  %memory_0 = call ccc i8* @malloc(i32 1656)
  %program_0 = bitcast i8* %memory_0 to %program*
  %0 = getelementptr %program, %program* %program_0, i32 0, i32 0
  call ccc void @symbol_table_init(%symbol_table* %0)
  %1 = getelementptr %program, %program* %program_0, i32 0, i32 1
  call ccc void @btree_init_empty_0(%btree_t_0* %1)
  %2 = getelementptr %program, %program* %program_0, i32 0, i32 2
  call ccc void @btree_init_empty_0(%btree_t_0* %2)
  %3 = getelementptr %program, %program* %program_0, i32 0, i32 3
  call ccc void @btree_init_empty_0(%btree_t_0* %3)
  %4 = getelementptr %program, %program* %program_0, i32 0, i32 4
  call ccc void @btree_init_empty_0(%btree_t_0* %4)
  %5 = getelementptr %program, %program* %program_0, i32 0, i32 5
  call ccc void @btree_init_empty_0(%btree_t_0* %5)
  %6 = getelementptr %program, %program* %program_0, i32 0, i32 6
  call ccc void @btree_init_empty_0(%btree_t_0* %6)
  %7 = getelementptr %program, %program* %program_0, i32 0, i32 0
  %8 = getelementptr inbounds [3 x i8], [3 x i8]* @string_literal_0, i32 0, i32 0
  %9 = zext i32 2 to i64
  %10 = call ccc i8* @malloc(i32 2)
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(i8* %10, i8* %8, i64 %9, i1 0)
  %11 = alloca %symbol_t, i32 1
  call ccc void @symbol_init(%symbol_t* %11, i32 2, i8* %10)
  %12 = call ccc i32 @symbol_table_find_or_insert(%symbol_table* %7, %symbol_t* %11)
  %13 = getelementptr %program, %program* %program_0, i32 0, i32 0
  %14 = getelementptr inbounds [3 x i8], [3 x i8]* @string_literal_1, i32 0, i32 0
  %15 = zext i32 2 to i64
  %16 = call ccc i8* @malloc(i32 2)
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(i8* %16, i8* %14, i64 %15, i1 0)
  %17 = alloca %symbol_t, i32 1
  call ccc void @symbol_init(%symbol_t* %17, i32 2, i8* %16)
  %18 = call ccc i32 @symbol_table_find_or_insert(%symbol_table* %13, %symbol_t* %17)
  %19 = getelementptr %program, %program* %program_0, i32 0, i32 0
  %20 = getelementptr inbounds [5 x i8], [5 x i8]* @string_literal_2, i32 0, i32 0
  %21 = zext i32 4 to i64
  %22 = call ccc i8* @malloc(i32 4)
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(i8* %22, i8* %20, i64 %21, i1 0)
  %23 = alloca %symbol_t, i32 1
  call ccc void @symbol_init(%symbol_t* %23, i32 4, i8* %22)
  %24 = call ccc i32 @symbol_table_find_or_insert(%symbol_table* %19, %symbol_t* %23)
  %25 = getelementptr %program, %program* %program_0, i32 0, i32 0
  %26 = getelementptr inbounds [10 x i8], [10 x i8]* @string_literal_3, i32 0, i32 0
  %27 = zext i32 9 to i64
  %28 = call ccc i8* @malloc(i32 9)
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(i8* %28, i8* %26, i64 %27, i1 0)
  %29 = alloca %symbol_t, i32 1
  call ccc void @symbol_init(%symbol_t* %29, i32 9, i8* %28)
  %30 = call ccc i32 @symbol_table_find_or_insert(%symbol_table* %25, %symbol_t* %29)
  ret %program* %program_0
}

define external ccc void @eclair_program_destroy(%program* %arg_0) "wasm-export-name"="eclair_program_destroy" {
start:
  %0 = getelementptr %program, %program* %arg_0, i32 0, i32 0
  call ccc void @symbol_table_destroy(%symbol_table* %0)
  %1 = getelementptr %program, %program* %arg_0, i32 0, i32 1
  call ccc void @btree_destroy_0(%btree_t_0* %1)
  %2 = getelementptr %program, %program* %arg_0, i32 0, i32 2
  call ccc void @btree_destroy_0(%btree_t_0* %2)
  %3 = getelementptr %program, %program* %arg_0, i32 0, i32 3
  call ccc void @btree_destroy_0(%btree_t_0* %3)
  %4 = getelementptr %program, %program* %arg_0, i32 0, i32 4
  call ccc void @btree_destroy_0(%btree_t_0* %4)
  %5 = getelementptr %program, %program* %arg_0, i32 0, i32 5
  call ccc void @btree_destroy_0(%btree_t_0* %5)
  %6 = getelementptr %program, %program* %arg_0, i32 0, i32 6
  call ccc void @btree_destroy_0(%btree_t_0* %6)
  %memory_0 = bitcast %program* %arg_0 to i8*
  call ccc void @free(i8* %memory_0)
  ret void
}

define external ccc void @btree_insert_range_delta_Reachable_Reachable(%btree_t_0* %tree_0, %btree_iterator_t_0* %begin_0, %btree_iterator_t_0* %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @btree_iterator_is_equal_0(%btree_iterator_t_0* %begin_0, %btree_iterator_t_0* %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc [2 x i32]* @btree_iterator_current_0(%btree_iterator_t_0* %begin_0)
  %3 = call ccc i1 @btree_insert_value_0(%btree_t_0* %tree_0, [2 x i32]* %2)
  call ccc void @btree_iterator_next_0(%btree_iterator_t_0* %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @btree_insert_range_Reachable_new_Reachable(%btree_t_0* %tree_0, %btree_iterator_t_0* %begin_0, %btree_iterator_t_0* %end_0) {
start:
  br label %while_begin_0
while_begin_0:
  %0 = call ccc i1 @btree_iterator_is_equal_0(%btree_iterator_t_0* %begin_0, %btree_iterator_t_0* %end_0)
  %1 = select i1 %0, i1 0, i1 1
  br i1 %1, label %while_body_0, label %while_end_0
while_body_0:
  %2 = call ccc [2 x i32]* @btree_iterator_current_0(%btree_iterator_t_0* %begin_0)
  %3 = call ccc i1 @btree_insert_value_0(%btree_t_0* %tree_0, [2 x i32]* %2)
  call ccc void @btree_iterator_next_0(%btree_iterator_t_0* %begin_0)
  br label %while_begin_0
while_end_0:
  ret void
}

define external ccc void @eclair_program_run(%program* %arg_0) "wasm-export-name"="eclair_program_run" {
start:
  %lower_bound_value_0 = alloca [2 x i32], i32 1
  %0 = getelementptr [2 x i32], [2 x i32]* %lower_bound_value_0, i32 0, i32 0
  store i32 0, i32* %0
  %1 = getelementptr [2 x i32], [2 x i32]* %lower_bound_value_0, i32 0, i32 1
  store i32 0, i32* %1
  %upper_bound_value_0 = alloca [2 x i32], i32 1
  %2 = getelementptr [2 x i32], [2 x i32]* %upper_bound_value_0, i32 0, i32 0
  store i32 4294967295, i32* %2
  %3 = getelementptr [2 x i32], [2 x i32]* %upper_bound_value_0, i32 0, i32 1
  store i32 4294967295, i32* %3
  %begin_iter_0 = alloca %btree_iterator_t_0, i32 1
  %end_iter_0 = alloca %btree_iterator_t_0, i32 1
  %4 = getelementptr %program, %program* %arg_0, i32 0, i32 1
  call ccc void @btree_lower_bound_0(%btree_t_0* %4, [2 x i32]* %lower_bound_value_0, %btree_iterator_t_0* %begin_iter_0)
  %5 = getelementptr %program, %program* %arg_0, i32 0, i32 1
  call ccc void @btree_upper_bound_0(%btree_t_0* %5, [2 x i32]* %upper_bound_value_0, %btree_iterator_t_0* %end_iter_0)
  br label %loop_0
loop_0:
  %condition_0 = call ccc i1 @btree_iterator_is_equal_0(%btree_iterator_t_0* %begin_iter_0, %btree_iterator_t_0* %end_iter_0)
  br i1 %condition_0, label %if_0, label %end_if_0
if_0:
  br label %range_query.end
end_if_0:
  %current_0 = call ccc [2 x i32]* @btree_iterator_current_0(%btree_iterator_t_0* %begin_iter_0)
  %value_0 = alloca [2 x i32], i32 1
  %6 = getelementptr [2 x i32], [2 x i32]* %value_0, i32 0, i32 0
  %7 = getelementptr [2 x i32], [2 x i32]* %current_0, i32 0, i32 0
  %8 = load i32, i32* %7
  store i32 %8, i32* %6
  %9 = getelementptr [2 x i32], [2 x i32]* %value_0, i32 0, i32 1
  %10 = getelementptr [2 x i32], [2 x i32]* %current_0, i32 0, i32 1
  %11 = load i32, i32* %10
  store i32 %11, i32* %9
  %12 = getelementptr %program, %program* %arg_0, i32 0, i32 2
  %13 = call ccc i1 @btree_insert_value_0(%btree_t_0* %12, [2 x i32]* %value_0)
  call ccc void @btree_iterator_next_0(%btree_iterator_t_0* %begin_iter_0)
  br label %loop_0
range_query.end:
  %begin_iter_1_0 = alloca %btree_iterator_t_0, i32 1
  %end_iter_1_0 = alloca %btree_iterator_t_0, i32 1
  %14 = getelementptr %program, %program* %arg_0, i32 0, i32 2
  call ccc void @btree_begin_0(%btree_t_0* %14, %btree_iterator_t_0* %begin_iter_1_0)
  %15 = getelementptr %program, %program* %arg_0, i32 0, i32 2
  call ccc void @btree_end_0(%btree_t_0* %15, %btree_iterator_t_0* %end_iter_1_0)
  %16 = getelementptr %program, %program* %arg_0, i32 0, i32 3
  call ccc void @btree_insert_range_delta_Reachable_Reachable(%btree_t_0* %16, %btree_iterator_t_0* %begin_iter_1_0, %btree_iterator_t_0* %end_iter_1_0)
  br label %loop_1
loop_1:
  %17 = getelementptr %program, %program* %arg_0, i32 0, i32 4
  call ccc void @btree_clear_0(%btree_t_0* %17)
  %lower_bound_value_1_0 = alloca [2 x i32], i32 1
  %18 = getelementptr [2 x i32], [2 x i32]* %lower_bound_value_1_0, i32 0, i32 0
  store i32 0, i32* %18
  %19 = getelementptr [2 x i32], [2 x i32]* %lower_bound_value_1_0, i32 0, i32 1
  store i32 0, i32* %19
  %upper_bound_value_1_0 = alloca [2 x i32], i32 1
  %20 = getelementptr [2 x i32], [2 x i32]* %upper_bound_value_1_0, i32 0, i32 0
  store i32 4294967295, i32* %20
  %21 = getelementptr [2 x i32], [2 x i32]* %upper_bound_value_1_0, i32 0, i32 1
  store i32 4294967295, i32* %21
  %begin_iter_2_0 = alloca %btree_iterator_t_0, i32 1
  %end_iter_2_0 = alloca %btree_iterator_t_0, i32 1
  %22 = getelementptr %program, %program* %arg_0, i32 0, i32 1
  call ccc void @btree_lower_bound_0(%btree_t_0* %22, [2 x i32]* %lower_bound_value_1_0, %btree_iterator_t_0* %begin_iter_2_0)
  %23 = getelementptr %program, %program* %arg_0, i32 0, i32 1
  call ccc void @btree_upper_bound_0(%btree_t_0* %23, [2 x i32]* %upper_bound_value_1_0, %btree_iterator_t_0* %end_iter_2_0)
  br label %loop_2
loop_2:
  %condition_1_0 = call ccc i1 @btree_iterator_is_equal_0(%btree_iterator_t_0* %begin_iter_2_0, %btree_iterator_t_0* %end_iter_2_0)
  br i1 %condition_1_0, label %if_1, label %end_if_1
if_1:
  br label %range_query.end_1
end_if_1:
  %current_1_0 = call ccc [2 x i32]* @btree_iterator_current_0(%btree_iterator_t_0* %begin_iter_2_0)
  %lower_bound_value_2_0 = alloca [2 x i32], i32 1
  %24 = getelementptr [2 x i32], [2 x i32]* %lower_bound_value_2_0, i32 0, i32 0
  %25 = getelementptr [2 x i32], [2 x i32]* %current_1_0, i32 0, i32 1
  %26 = load i32, i32* %25
  store i32 %26, i32* %24
  %27 = getelementptr [2 x i32], [2 x i32]* %lower_bound_value_2_0, i32 0, i32 1
  store i32 0, i32* %27
  %upper_bound_value_2_0 = alloca [2 x i32], i32 1
  %28 = getelementptr [2 x i32], [2 x i32]* %upper_bound_value_2_0, i32 0, i32 0
  %29 = getelementptr [2 x i32], [2 x i32]* %current_1_0, i32 0, i32 1
  %30 = load i32, i32* %29
  store i32 %30, i32* %28
  %31 = getelementptr [2 x i32], [2 x i32]* %upper_bound_value_2_0, i32 0, i32 1
  store i32 4294967295, i32* %31
  %begin_iter_3_0 = alloca %btree_iterator_t_0, i32 1
  %end_iter_3_0 = alloca %btree_iterator_t_0, i32 1
  %32 = getelementptr %program, %program* %arg_0, i32 0, i32 3
  call ccc void @btree_lower_bound_0(%btree_t_0* %32, [2 x i32]* %lower_bound_value_2_0, %btree_iterator_t_0* %begin_iter_3_0)
  %33 = getelementptr %program, %program* %arg_0, i32 0, i32 3
  call ccc void @btree_upper_bound_0(%btree_t_0* %33, [2 x i32]* %upper_bound_value_2_0, %btree_iterator_t_0* %end_iter_3_0)
  br label %loop_3
loop_3:
  %condition_2_0 = call ccc i1 @btree_iterator_is_equal_0(%btree_iterator_t_0* %begin_iter_3_0, %btree_iterator_t_0* %end_iter_3_0)
  br i1 %condition_2_0, label %if_2, label %end_if_2
if_2:
  br label %range_query.end_2
end_if_2:
  %current_2_0 = call ccc [2 x i32]* @btree_iterator_current_0(%btree_iterator_t_0* %begin_iter_3_0)
  %value_1_0 = alloca [2 x i32], i32 1
  %34 = getelementptr [2 x i32], [2 x i32]* %value_1_0, i32 0, i32 0
  %35 = getelementptr [2 x i32], [2 x i32]* %current_1_0, i32 0, i32 0
  %36 = load i32, i32* %35
  store i32 %36, i32* %34
  %37 = getelementptr [2 x i32], [2 x i32]* %value_1_0, i32 0, i32 1
  %38 = getelementptr [2 x i32], [2 x i32]* %current_2_0, i32 0, i32 1
  %39 = load i32, i32* %38
  store i32 %39, i32* %37
  %contains_result_0 = getelementptr %program, %program* %arg_0, i32 0, i32 2
  %contains_result_1 = call ccc i1 @btree_contains_0(%btree_t_0* %contains_result_0, [2 x i32]* %value_1_0)
  %condition_3_0 = select i1 %contains_result_1, i1 0, i1 1
  br i1 %condition_3_0, label %if_3, label %end_if_3
if_3:
  %value_2_0 = alloca [2 x i32], i32 1
  %40 = getelementptr [2 x i32], [2 x i32]* %value_2_0, i32 0, i32 0
  %41 = getelementptr [2 x i32], [2 x i32]* %current_1_0, i32 0, i32 0
  %42 = load i32, i32* %41
  store i32 %42, i32* %40
  %43 = getelementptr [2 x i32], [2 x i32]* %value_2_0, i32 0, i32 1
  %44 = getelementptr [2 x i32], [2 x i32]* %current_2_0, i32 0, i32 1
  %45 = load i32, i32* %44
  store i32 %45, i32* %43
  %46 = getelementptr %program, %program* %arg_0, i32 0, i32 4
  %47 = call ccc i1 @btree_insert_value_0(%btree_t_0* %46, [2 x i32]* %value_2_0)
  br label %end_if_3
end_if_3:
  call ccc void @btree_iterator_next_0(%btree_iterator_t_0* %begin_iter_3_0)
  br label %loop_3
range_query.end_2:
  call ccc void @btree_iterator_next_0(%btree_iterator_t_0* %begin_iter_2_0)
  br label %loop_2
range_query.end_1:
  %condition_4_0 = getelementptr %program, %program* %arg_0, i32 0, i32 4
  %condition_4_1 = call ccc i1 @btree_is_empty_0(%btree_t_0* %condition_4_0)
  br i1 %condition_4_1, label %if_4, label %end_if_4
if_4:
  br label %loop.end
end_if_4:
  %begin_iter_4_0 = alloca %btree_iterator_t_0, i32 1
  %end_iter_4_0 = alloca %btree_iterator_t_0, i32 1
  %48 = getelementptr %program, %program* %arg_0, i32 0, i32 4
  call ccc void @btree_begin_0(%btree_t_0* %48, %btree_iterator_t_0* %begin_iter_4_0)
  %49 = getelementptr %program, %program* %arg_0, i32 0, i32 4
  call ccc void @btree_end_0(%btree_t_0* %49, %btree_iterator_t_0* %end_iter_4_0)
  %50 = getelementptr %program, %program* %arg_0, i32 0, i32 2
  call ccc void @btree_insert_range_Reachable_new_Reachable(%btree_t_0* %50, %btree_iterator_t_0* %begin_iter_4_0, %btree_iterator_t_0* %end_iter_4_0)
  %51 = getelementptr %program, %program* %arg_0, i32 0, i32 4
  %52 = getelementptr %program, %program* %arg_0, i32 0, i32 3
  call ccc void @btree_swap_0(%btree_t_0* %51, %btree_t_0* %52)
  br label %loop_1
loop.end:
  ret void
}

define external ccc void @eclair_add_facts(%program* %eclair_program_0, i32 %fact_type_0, i32* %memory_0, i32 %fact_count_0) "wasm-export-name"="eclair_add_facts" {
start:
  switch i32 %fact_type_0, label %switch.default_0 [i32 2, label %Edge_0 i32 0, label %x1_0 i32 1, label %x2_0]
Edge_0:
  %0 = getelementptr %program, %program* %eclair_program_0, i32 0, i32 1
  %1 = bitcast i32* %memory_0 to [2 x i32]*
  br label %for_begin_0
for_begin_0:
  %2 = phi i32 [0, %Edge_0], [%6, %for_body_0]
  %3 = icmp ult i32 %2, %fact_count_0
  br i1 %3, label %for_body_0, label %for_end_0
for_body_0:
  %4 = getelementptr [2 x i32], [2 x i32]* %1, i32 %2
  %5 = call ccc i1 @btree_insert_value_0(%btree_t_0* %0, [2 x i32]* %4)
  %6 = add i32 1, %2
  br label %for_begin_0
for_end_0:
  br label %x1_0
x1_0:
  %7 = getelementptr %program, %program* %eclair_program_0, i32 0, i32 5
  %8 = bitcast i32* %memory_0 to [2 x i32]*
  br label %for_begin_1
for_begin_1:
  %9 = phi i32 [0, %x1_0], [%13, %for_body_1]
  %10 = icmp ult i32 %9, %fact_count_0
  br i1 %10, label %for_body_1, label %for_end_1
for_body_1:
  %11 = getelementptr [2 x i32], [2 x i32]* %8, i32 %9
  %12 = call ccc i1 @btree_insert_value_0(%btree_t_0* %7, [2 x i32]* %11)
  %13 = add i32 1, %9
  br label %for_begin_1
for_end_1:
  br label %x2_0
x2_0:
  %14 = getelementptr %program, %program* %eclair_program_0, i32 0, i32 6
  %15 = bitcast i32* %memory_0 to [2 x i32]*
  br label %for_begin_2
for_begin_2:
  %16 = phi i32 [0, %x2_0], [%20, %for_body_2]
  %17 = icmp ult i32 %16, %fact_count_0
  br i1 %17, label %for_body_2, label %for_end_2
for_body_2:
  %18 = getelementptr [2 x i32], [2 x i32]* %15, i32 %16
  %19 = call ccc i1 @btree_insert_value_0(%btree_t_0* %14, [2 x i32]* %18)
  %20 = add i32 1, %16
  br label %for_begin_2
for_end_2:
  br label %switch.default_0
switch.default_0:
  ret void
}

define external ccc void @eclair_add_fact(%program* %eclair_program_0, i32 %fact_type_0, i32* %memory_0) "wasm-export-name"="eclair_add_fact" {
start:
  call ccc void @eclair_add_facts(%program* %eclair_program_0, i32 %fact_type_0, i32* %memory_0, i32 1)
  ret void
}

define external ccc i32* @eclair_get_facts(%program* %eclair_program_0, i32 %fact_type_0) "wasm-export-name"="eclair_get_facts" {
start:
  switch i32 %fact_type_0, label %switch.default_0 [i32 3, label %Reachable_0 i32 0, label %x1_0 i32 1, label %x2_0]
Reachable_0:
  %0 = getelementptr %program, %program* %eclair_program_0, i32 0, i32 2
  %fact_count_0 = call ccc i64 @btree_size_0(%btree_t_0* %0)
  %fact_count_1 = trunc i64 %fact_count_0 to i32
  %byte_count_0 = mul i32 %fact_count_1, 8
  %memory_0 = call ccc i8* @malloc(i32 %byte_count_0)
  %array_0 = bitcast i8* %memory_0 to [2 x i32]*
  %i_0 = alloca i32, i32 1
  store i32 0, i32* %i_0
  %current_iter_0 = alloca %btree_iterator_t_0, i32 1
  %end_iter_0 = alloca %btree_iterator_t_0, i32 1
  call ccc void @btree_begin_0(%btree_t_0* %0, %btree_iterator_t_0* %current_iter_0)
  call ccc void @btree_end_0(%btree_t_0* %0, %btree_iterator_t_0* %end_iter_0)
  br label %while_begin_0
while_begin_0:
  %1 = call ccc i1 @btree_iterator_is_equal_0(%btree_iterator_t_0* %current_iter_0, %btree_iterator_t_0* %end_iter_0)
  %2 = select i1 %1, i1 0, i1 1
  br i1 %2, label %while_body_0, label %while_end_0
while_body_0:
  %3 = load i32, i32* %i_0
  %value_0 = getelementptr [2 x i32], [2 x i32]* %array_0, i32 %3
  %current_0 = call ccc [2 x i32]* @btree_iterator_current_0(%btree_iterator_t_0* %current_iter_0)
  %4 = getelementptr [2 x i32], [2 x i32]* %current_0, i32 0
  %5 = load [2 x i32], [2 x i32]* %4
  %6 = getelementptr [2 x i32], [2 x i32]* %value_0, i32 0
  store [2 x i32] %5, [2 x i32]* %6
  %7 = add i32 %3, 1
  store i32 %7, i32* %i_0
  call ccc void @btree_iterator_next_0(%btree_iterator_t_0* %current_iter_0)
  br label %while_begin_0
while_end_0:
  %8 = bitcast i8* %memory_0 to i32*
  ret i32* %8
x1_0:
  %9 = getelementptr %program, %program* %eclair_program_0, i32 0, i32 5
  %fact_count_2 = call ccc i64 @btree_size_0(%btree_t_0* %9)
  %fact_count_3 = trunc i64 %fact_count_2 to i32
  %byte_count_1 = mul i32 %fact_count_3, 8
  %memory_1 = call ccc i8* @malloc(i32 %byte_count_1)
  %array_1 = bitcast i8* %memory_1 to [2 x i32]*
  %i_1 = alloca i32, i32 1
  store i32 0, i32* %i_1
  %current_iter_1 = alloca %btree_iterator_t_0, i32 1
  %end_iter_1 = alloca %btree_iterator_t_0, i32 1
  call ccc void @btree_begin_0(%btree_t_0* %9, %btree_iterator_t_0* %current_iter_1)
  call ccc void @btree_end_0(%btree_t_0* %9, %btree_iterator_t_0* %end_iter_1)
  br label %while_begin_1
while_begin_1:
  %10 = call ccc i1 @btree_iterator_is_equal_0(%btree_iterator_t_0* %current_iter_1, %btree_iterator_t_0* %end_iter_1)
  %11 = select i1 %10, i1 0, i1 1
  br i1 %11, label %while_body_1, label %while_end_1
while_body_1:
  %12 = load i32, i32* %i_1
  %value_1 = getelementptr [2 x i32], [2 x i32]* %array_1, i32 %12
  %current_1 = call ccc [2 x i32]* @btree_iterator_current_0(%btree_iterator_t_0* %current_iter_1)
  %13 = getelementptr [2 x i32], [2 x i32]* %current_1, i32 0
  %14 = load [2 x i32], [2 x i32]* %13
  %15 = getelementptr [2 x i32], [2 x i32]* %value_1, i32 0
  store [2 x i32] %14, [2 x i32]* %15
  %16 = add i32 %12, 1
  store i32 %16, i32* %i_1
  call ccc void @btree_iterator_next_0(%btree_iterator_t_0* %current_iter_1)
  br label %while_begin_1
while_end_1:
  %17 = bitcast i8* %memory_1 to i32*
  ret i32* %17
x2_0:
  %18 = getelementptr %program, %program* %eclair_program_0, i32 0, i32 6
  %fact_count_4 = call ccc i64 @btree_size_0(%btree_t_0* %18)
  %fact_count_5 = trunc i64 %fact_count_4 to i32
  %byte_count_2 = mul i32 %fact_count_5, 8
  %memory_2 = call ccc i8* @malloc(i32 %byte_count_2)
  %array_2 = bitcast i8* %memory_2 to [2 x i32]*
  %i_2 = alloca i32, i32 1
  store i32 0, i32* %i_2
  %current_iter_2 = alloca %btree_iterator_t_0, i32 1
  %end_iter_2 = alloca %btree_iterator_t_0, i32 1
  call ccc void @btree_begin_0(%btree_t_0* %18, %btree_iterator_t_0* %current_iter_2)
  call ccc void @btree_end_0(%btree_t_0* %18, %btree_iterator_t_0* %end_iter_2)
  br label %while_begin_2
while_begin_2:
  %19 = call ccc i1 @btree_iterator_is_equal_0(%btree_iterator_t_0* %current_iter_2, %btree_iterator_t_0* %end_iter_2)
  %20 = select i1 %19, i1 0, i1 1
  br i1 %20, label %while_body_2, label %while_end_2
while_body_2:
  %21 = load i32, i32* %i_2
  %value_2 = getelementptr [2 x i32], [2 x i32]* %array_2, i32 %21
  %current_2 = call ccc [2 x i32]* @btree_iterator_current_0(%btree_iterator_t_0* %current_iter_2)
  %22 = getelementptr [2 x i32], [2 x i32]* %current_2, i32 0
  %23 = load [2 x i32], [2 x i32]* %22
  %24 = getelementptr [2 x i32], [2 x i32]* %value_2, i32 0
  store [2 x i32] %23, [2 x i32]* %24
  %25 = add i32 %21, 1
  store i32 %25, i32* %i_2
  call ccc void @btree_iterator_next_0(%btree_iterator_t_0* %current_iter_2)
  br label %while_begin_2
while_end_2:
  %26 = bitcast i8* %memory_2 to i32*
  ret i32* %26
switch.default_0:
  ret i32* zeroinitializer
}

define external ccc void @eclair_free_buffer(i32* %buffer_0) "wasm-export-name"="eclair_free_buffer" {
start:
  %memory_0 = bitcast i32* %buffer_0 to i8*
  call ccc void @free(i8* %memory_0)
  ret void
}

define external ccc i32 @eclair_fact_count(%program* %eclair_program_0, i32 %fact_type_0) "wasm-export-name"="eclair_fact_count" {
start:
  switch i32 %fact_type_0, label %switch.default_0 [i32 3, label %Reachable_0 i32 0, label %x1_0 i32 1, label %x2_0]
Reachable_0:
  %0 = getelementptr %program, %program* %eclair_program_0, i32 0, i32 2
  %1 = call ccc i64 @btree_size_0(%btree_t_0* %0)
  %2 = trunc i64 %1 to i32
  ret i32 %2
x1_0:
  %3 = getelementptr %program, %program* %eclair_program_0, i32 0, i32 5
  %4 = call ccc i64 @btree_size_0(%btree_t_0* %3)
  %5 = trunc i64 %4 to i32
  ret i32 %5
x2_0:
  %6 = getelementptr %program, %program* %eclair_program_0, i32 0, i32 6
  %7 = call ccc i64 @btree_size_0(%btree_t_0* %6)
  %8 = trunc i64 %7 to i32
  ret i32 %8
switch.default_0:
  ret i32 0
}

define external ccc i32 @eclair_encode_string(%program* %eclair_program_0, i32 %string_length_0, i8* %string_data_0) "wasm-export-name"="eclair_encode_string" {
start:
  %0 = call ccc i8* @malloc(i32 %string_length_0)
  %1 = zext i32 %string_length_0 to i64
  call ccc void @llvm.memcpy.p0i8.p0i8.i64(i8* %0, i8* %string_data_0, i64 %1, i1 0)
  %2 = alloca %symbol_t, i32 1
  call ccc void @symbol_init(%symbol_t* %2, i32 %string_length_0, i8* %0)
  %3 = getelementptr %program, %program* %eclair_program_0, i32 0, i32 0
  %4 = call ccc i32 @symbol_table_lookup_index(%symbol_table* %3, %symbol_t* %2)
  %5 = icmp ne i32 %4, 4294967295
  br i1 %5, label %if_0, label %end_if_0
if_0:
  call ccc void @free(i8* %0)
  ret i32 %4
end_if_0:
  %6 = call ccc i32 @symbol_table_find_or_insert(%symbol_table* %3, %symbol_t* %2)
  ret i32 %6
}

define external ccc i8* @eclair_decode_string(%program* %eclair_program_0, i32 %string_index_0) "wasm-export-name"="eclair_decode_string" {
start:
  %0 = getelementptr %program, %program* %eclair_program_0, i32 0, i32 0
  %1 = call ccc i1 @symbol_table_contains_index(%symbol_table* %0, i32 %string_index_0)
  br i1 %1, label %if_0, label %end_if_0
if_0:
  %2 = call ccc %symbol_t* @symbol_table_lookup_symbol(%symbol_table* %0, i32 %string_index_0)
  %3 = bitcast %symbol_t* %2 to i8*
  ret i8* %3
end_if_0:
  ret i8* zeroinitializer
}
