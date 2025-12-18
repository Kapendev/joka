use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    let n: i32 = if args.len() > 1 { args[1].parse().unwrap_or(0) } else { 0 };
    if n == 0 {
        println!("Usage: array_append_remove <count>");
        return;
    }

    let mut array: Vec<i32> = Vec::new();
    for i in 0 .. n {
        array.push(i as i32);
    }
    while !array.is_empty() {
        array.pop();
    }
}
