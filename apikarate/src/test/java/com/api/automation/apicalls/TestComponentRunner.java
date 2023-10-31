package com.api.automation.apicalls;


import com.intuit.karate.junit5.Karate;
import com.intuit.karate.junit5.Karate.Test;

public class TestComponentRunner {
	
	@Test
	public Karate runTest() {
		return Karate.run("apikarate").relativeTo(getClass());
		
	}
}
