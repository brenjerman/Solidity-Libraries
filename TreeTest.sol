import "RedBlackTree.sol";

contract TreeTest {
  using RedBlackTree for *;
  bool [] public results;

  function test1() {
    RedBlackTree.Tree tree;
    delete results;

    tree.insert(20,20);
    tree.insert(15,15);
    tree.insert(25,25);
    tree.insert(10,10);

    uint32 nodeP = tree.root;
    results.push(isBlack(nodeP) != 0);

    nodeP = tree.search(15);
    results.push(isBlack(nodeP) != 0);

    nodeP = tree.search(25);
    results.push(isBlack(nodeP) != 0);

    tree.insert(17,17);
    tree.insert(8,8);

    nodeP = tree.search(15);
    results.push(isBlack(nodeP) == 0);

    nodeP = tree.search(10);
    results.push(isBlack(nodeP) != 0);

    nodeP = tree.search(17);
    results.push(isBlack(nodeP) != 0);

    nodeP = tree.search(8);
    results.push(isBlack(nodeP) == 0);

    tree.insert(9,9);

    nodeP = tree.search(10);
    results.push(isBlack(nodeP) == 0);

    nodeP = tree.search(8);
    results.push(isBlack(nodeP) != 0);

    nodeP = left(tree.search(9));
    results.push(key(nodeP) == 8);

    results.push(testBSTProps(tree.root));
  }

  function test2() {
    RBT tree;
    delete results;

    tree.insert(20,20);
    tree.insert(15,15);
    tree.insert(25,25);
    tree.insert(23,23);

    uint32 nodeP = tree.root;
    results.push(isBlack(nodeP));
    results.push(tree.size == 4);

    tree.remove(15);
    results.push(tree.size == 3);

    nodeP = tree.root;
    results.push(value(nodeP) == 23);

    results.push(testBSTProps(tree.root));
  }

  function test3() {
    RBT tree;
    delete results;

    tree.insert(20,20);
    tree.insert(15,15);
    tree.insert(25,25);
    tree.insert(23,23);
    tree.insert(27,27);

    uint32 nodeP = tree.root;
    results.push(isBlack(nodeP));
    results.push(tree.size == 5);

    nodeP = right(tree.root);
    results.push(key(nodeP) == 25);

    nodeP = left(right(tree.root));
    results.push(key(nodeP) == 23);
    results.push(isBlack(nodeP) == 0);

    tree.remove(25);
    results.push(tree.size == 4);
   
    nodeP = tree.root;
    results.push(key(nodeP) == 20);
    
    nodeP = right(tree.root);
    results.push(key(nodeP) == 27);
    results.push(isBlack(nodeP) != 0);
    
    nodeP = right(right(tree.root));
    results.push(nodeP == 0);
    
    nodeP = left(right(tree.root));
    results.push(key(nodeP) == 23);
    results.push(isBlack(nodeP) == 0);
    
    results.push(testBSTProps(tree.root));
  }

  function testBSTProps(uint32 root) returns (bool succ) { 
    succ = true;
    if (root != 0) {
      if (left(root) != 0)
        succ &= key(root) >= key(left(root));
      if (right(root) != 0)
        succ &= key(root) <= key(right(root));
      succ &= testBSTProps(left(root));
      succ &= testBSTProps(right(root));
    }
  }
}
