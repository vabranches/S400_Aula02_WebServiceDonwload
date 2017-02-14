import UIKit

class ViewController: UIViewController , URLSessionDownloadDelegate{
    
    //MARK: Propriedades
    var arrayImagens = ["https://upload.wikimedia.org/wikipedia/commons/9/92/Apple_Watch-.jpg"
                        , "https://static.pexels.com/photos/39803/pexels-photo-39803.jpeg"
                        , "https://static.independent.co.uk/s3fs-public/thumbnails/image/2016/02/04/16/appletimcook.jpg"
                        , "https://img.elo7.com.br/product/original/ED2422/3x-adesivo-apple-branco-notebook-celular-ipad.jpg"]
    var minhaSession : URLSession!
    var minhaConfig : URLSessionConfiguration!
    var imagemAtual : Int!
    
    
    //MARK: Outlets
    @IBOutlet weak var minhaImageView: UIImageView!
    @IBOutlet weak var meuProgress: UIProgressView!
    
    //MARK: Actions
    @IBAction func baixar(_ sender: UIButton) {
        
        fazerDownload()
        
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Inicializando as propriedades
        minhaConfig = .default
        meuProgress.isHidden = true
        
        imagemAtual = 0
        //fazerDownload()


    }
    
    //MARK: Métodos Personalizados
    func fazerDownload() {
        
        self.meuProgress.setProgress(0.0, animated: false)
        self.minhaImageView.image = nil
        
        guard let minhaURL = URL(string: arrayImagens[imagemAtual]) else {return}

        
        minhaSession = URLSession(configuration: minhaConfig, delegate: self, delegateQueue: nil)
        
        let tarefa = minhaSession.downloadTask(with: minhaURL)
        
        tarefa.resume()
        
        if imagemAtual >= arrayImagens.count - 1 {
            imagemAtual = 0
        } else {
            imagemAtual = imagemAtual + 1
        }
    }
    
    //MARK: Métodos de URLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        let imagemData = try! Data(contentsOf: location)
        let imagemBaixada = UIImage(data: imagemData)
        
        DispatchQueue.main.async {
            self.minhaImageView.image = imagemBaixada
            self.meuProgress.isHidden = true
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        let totalDownload = Float(totalBytesWritten * 100 / totalBytesExpectedToWrite) / 100
        
        DispatchQueue.main.async {
            self.meuProgress.isHidden = false
            self.meuProgress.setProgress(totalDownload, animated: true)
        }
        
    }


}

