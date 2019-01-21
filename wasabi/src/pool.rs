#[derive(Debug)]
pub struct Pool<T> {
    pointer: usize,
    items: Vec<Option<T>>,
}

// This yields poor performance with large numbers and frequent sparse item
// removal. Should swap out for something else at some point.
impl<T> Pool<T> {
    pub fn new() -> Self {
        Self {
            pointer: 0,
            items: Vec::new(),
        }
    }
    pub fn add(&mut self, nt: T) -> usize {
        let id = self.pointer;
        if self.pointer == self.items.len() {
            self.items.push(Some(nt));
            self.pointer += 1;
        } else {
            self.items[self.pointer] = Some(nt);
            for ref item in self.items[self.pointer + 1..].iter() {
                self.pointer += 1;
                match item {
                    None => {
                        return id;
                    }
                    _ => {}
                }
            }
        }
        id
    }
    pub fn next_id(&self) -> usize {
        self.pointer
    }
    pub fn get(&self, i: usize) -> Option<&T> {
        match self.items.get(i) {
            Some(ot) => match ot {
                Some(t) => Some(t),
                None => None,
            },
            None => None,
        }
    }
    pub fn get_mut(&mut self, i: usize) -> Option<&mut T> {
        match self.items.get_mut(i) {
            Some(ot) => match ot {
                Some(t) => Some(t),
                None => None,
            },
            None => None,
        }
    }
    pub fn is_empty(&self) -> bool {
        self.pointer == 0
    }
    pub fn remove(&mut self, i: usize) {
        if i > self.items.len() {
            panic!("index out of range")
        }
        self.items[i] = None;
        if i < self.pointer {
            self.pointer = i
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_functionality() {
        let mut p: Pool<i32> = Pool::new();
        assert_eq!(p.is_empty(), true);

        let four = p.add(4); //0
        p.add(34); //1
        let fifty_six = p.add(56); //2
        p.add(56); //3
        assert_eq!(p.get(four), Some(&4i32));
        assert_eq!(p.next_id(), 4);
        p.remove(four);
        assert_eq!(p.next_id(), 0);
        let four = p.add(4);
        assert_eq!(four, 0);
        assert_eq!(p.next_id(), 3);
        p.remove(fifty_six);
        assert_eq!(p.next_id(), 2);
        p.add(2435);
        p.add(3123);
    }

    #[test]
    fn test_mut() {
        let mut p: Pool<Vec<u8>> = Pool::new();
        let index = p.add(vec![0, 1]);
        {
            let thing = p.get_mut(index).unwrap();
            thing.push(2);
        }
        assert_eq!(p.get(index).unwrap(), &vec![0, 1, 2]);
    }
}
