fn main() {
    println!("Hello, world!");
    let mut a = 4;
    test(&mut a);
    println!("{}", a);
}

fn test(a: &mut i32) {
    *a -= 1;
    println!("{}", a);
}