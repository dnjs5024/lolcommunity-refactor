package com.example.demo.riot.component;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import lombok.extern.slf4j.Slf4j;
@Component
@Slf4j
public class RiotData {
	@Value("${riot.api.key}")
	private String riotApiKey;

	@javax.annotation.PostConstruct
	public void init() {
		if (riotApiKey == null || riotApiKey.trim().isEmpty()) {
			log.warn("RIOT_API_KEY is empty! API requests will fail.");
		} else {
			log.info("RIOT_API_KEY loaded: {}...", riotApiKey.substring(0, Math.min(10, riotApiKey.length())));
		}
	}

	public String getStaticReadData(String urlStr) {
		URL url;
		try {
			url = new URL(urlStr);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			int responseCode = con.getResponseCode();
			BufferedReader br;
			if (responseCode == 200) {
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else {
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}
			String inputLine;
			StringBuffer response = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				response.append(inputLine);
			}
			br.close();
			return response.toString();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
	public String getReadData(String urlStr) {
		URL url;
		try {
			url = new URL(urlStr);
			log.info("Api Key -> {}",riotApiKey);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setRequestMethod("GET");
			con.setRequestProperty("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36");
			con.setRequestProperty("Accept-Language", "ko-KR,ko;q=0.9,en-US;q=0.8,en;q=0.7");
			con.setRequestProperty("Accept-Charset", "application/x-www-form-urlencoded; charset=UTF-8");
			con.setRequestProperty("X-Riot-Token", riotApiKey);
			int responseCode = con.getResponseCode();
			BufferedReader br;
			if (responseCode == 200) {
				br = new BufferedReader(new InputStreamReader(con.getInputStream()));
			} else {
				if(con.getErrorStream() == null) {
					log.error("API 요청 실패: responseCode={}, url={}", responseCode, urlStr);
					return null;
				}
				br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
			}
			String inputLine;
			StringBuffer response = new StringBuffer();
			while ((inputLine = br.readLine()) != null) {
				response.append(inputLine);
			}
			br.close();
			return response.toString();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}
}
