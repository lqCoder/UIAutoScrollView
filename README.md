#UIAutoScrollView
    在开发过程中，如一个页面有许多的输入控件，UITextField和UITextView。编码的时候就要考虑控件获得焦点后，键盘是否会把这个控件遮 <br />挡，就得操作UIScrollView的滚动条位置。
   <br /> 我开发了UIAutoScrollView类，它能自动处理键盘遮挡问题，达到了一劳永逸的效果！
<br />![github](https://github.com/lqCoder/UIAutoScrollView/blob/master/AutoScrollGif.gif "github")
##使用注意
   <br /> 1.如果是xib的方式使用这个类，不需要调用这个addAutoScrollAbility方法，我在awakeFromNib方法里调用了。 在xib中使用时，先在
xib中拖入一个UIScrollView，然后再把它的class属性设置为 UIAutoScrollView
  <br />  2.如我在Demo 中的CodeScrollTestViewController中用UIAutoScrollView。必须设置UIAutoScrollView的contentSize，在加完
UIAutoScrollView的所有子控件的后，最后再调用下addAutoScrollAbility方法，这个顺序不能变。
  <br />  3.如我在Demo 中的CodeScrollTestViewController中用UIAutoScrollView。在viewDidLoad中设置了
self.view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen 
mainScreen].bounds.size.height-self.navigationController.navigationBar.frame.size.height-[UIApplication 
sharedApplication].statusBarFrame.size.height);     这里必须设置下view的frame，原因是这时候view的高度已经超出了手机屏幕。
超出了navigationBar和statusBar的高度. 如果不这样设置后面的代码设置UIAutoScrollView的frame等于view的frame的时候，会造成
UIAutoScrollView超出手机屏幕，这样在UIAutoScrollView内部计算的时候会出bug.


