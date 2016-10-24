//
//  OAuthViewController.swift
//  Weibo
//
//  Created by 陈伟涵 on 2016/10/18.
//  Copyright © 2016年 cweihan. All rights reserved.
//

import UIKit
import SVProgressHUD

class OAuthViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.delegate = self

        // Do any additional setup after loading the view.
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(WB_App_Key)&redirect_uri=\(WB_Redirect_uri)"
        
        guard let url = URL(string: urlStr) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        webView.loadRequest(request)
    }
    
    @IBAction func clickClose() {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func tianchong() {
    }
}

extension OAuthViewController : UIWebViewDelegate{
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        //显示提醒
       SVProgressHUD.showInfo(withStatus: "正在加载中...")
        
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        /*
         登录界面：https://api.weibo.com/oauth2/authorize?client_id=3090663153&redirect_uri=http://www.baidu.com
         输入账号密码之后：https://api.weibo.com/oauth2/authorize
         取消授权:http://www.520it.com/?error_uri=%2Foauth2%2Fauthorize&error=access_denied&error_description=user%20denied%20your%20request.&error_code=21330
         授权:http://www.520it.com/?code=c2796542e264da89367f993131e6c904
         通过观察
         1.如果是授权成功获取失败都会跳转到授权回调页面
         2.如果授权回调页面包含code=就代表授权成功, 需要截取code=后面字符串
         3.而且如果是授权回调页面不需要显示给用户看, 返回false
         */
        
        //判断当前是否是授权回调页面
        guard let urlStr = request.url?.absoluteString else {
            return false
        }
        if !urlStr.hasPrefix(WB_Redirect_uri) {
            print("不是授权回调页面")
            return true
        }
        print("是授权回调页面")
        //判断授权回调的地址中是否包含code=
        let key = "code="
        guard let str = request.url?.query else {
            return false
        }
        
        if str.hasPrefix(key) {
            let code = str.substring(from: key.endIndex)
            let codeStr = (code as NSString).substring(to: 32)
            loadAccessToken(codeStr : codeStr)
            return false
        }
        print("授权失败")
        return false
    }
    
    private func loadAccessToken(codeStr : String) {
        
        // 注意:redirect_uri必须和开发中平台中填写的一模一样
        // 1.准备请求路径
        let path = "https://api.weibo.com/oauth2/access_token"
        
        // 2.准备请求参数
        let params = ["client_id": WB_App_Key, "client_secret": WB_App_Secret, "grant_type": "authorization_code", "code": codeStr, "redirect_uri": WB_Redirect_uri]
        
        NetworkTool.shareInstance.post(path, parameters: params, progress: nil, success: { (task: URLSessionDataTask, responseObj: Any?) in
            
            let account = UserAccount.init(dict: responseObj as! [String : AnyObject])
           
            //获取用户信息
            account.loadUserInfo(finished: { (account, error) in
                account?.saveAccount()
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WHSwitchRootViewController), object: false)
                
                self.clickClose()
                
            })
            
        }) { (task: URLSessionDataTask?, error: Error) in
            print(error)
        }
       
        
        
    }
    
    
}

