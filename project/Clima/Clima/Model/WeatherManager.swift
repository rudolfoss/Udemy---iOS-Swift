//
//  WeatherManger.swift
//  Clima
//
//  Created by HA on 2022/07/30.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherMangager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error : Error)
        
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=1f720009a1864da6f7950bc43b708ddf&units=metric"
    
    
    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityName: String){
        
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    
    func performRequest(with urlString : String){
        //1. create a url
        if let url = URL(string: urlString){
            //2. create a url session
            //url세션을 정하고 객체로 설정. -> 네트워킹 가능
            let session = URLSession(configuration: .default)
            
            //3. give the session a task
            //세션에 작업을 부여. 즉 지정된 url의 내용을 검색한 다음 처리기 또는 메소드 호출하는 작업만들기, 데이터확보
            let task = session.dataTask(with: url) { (data, response, error) in
            //completion handler: 함수를 값으로 취함.
            
                //네트워킹에 오류있는지 체크
                if error != nil{ //오류가 나면
                    self.delegate?.didFailWithError(error: error!)
                    return //이 기능을 종료하고 계속하지 마십시오.
                }
                if let safeData = data { //선택적 바인딩을 사용하여 래핑해제
                    if let weather = self.pasreJSON(safeData) { // weatherviewcontroller로 부터 가져오기
                        self.delegate?.didUpdateWeather(self, weather: weather) // 클로저 안에 있기 때문에 self 있어야함
                    }
                }
            }
            //4. start the task
            task.resume()
        }
    }
    
    func pasreJSON(_ weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
                    
    }catch{
        delegate?.didFailWithError(error: error)
        return nil
    }
}
    
}
